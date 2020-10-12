#!/bin/bash
set -e
# This is a simple script that automates the downloading of specific binaries that I use all the time
# The formatting of the binary will abid by the "configure.sh"

## Global Variables
MAIN_BINARY_PATH="$HOME/CLI_Tools"

usage() {
    cat << EOF
$(basename "$0") [-d] [-v] [-p] [-h] -- Downloads binary files quickly and formatted them properly

This script automates downloading specific binary files that are useful for myself. These binaries are formatted and placed in specific locations that work in conjunction with configure.sh. The following filepaths are used (and can be configured):
    
    Main Binary Path = ${HOME}/CLI_Tools
    
FLAGS:
    -d:     Downloads the given terraform version
    -v:     Switches to the given terraform version
    -p:     Specified a new Binary Path to utilize (optional; defaults to ${HOME}/CLI_Tools)
    -h:     Shows this help page

EXAMPLES:
    1.) ./$(basename "$0") -d binary_name -v X.Y.Z
        Downloads the specified binary name with X.Y.Z version and puts it in the MAIN_BINARY_PATH (defaults to ${HOME}/CLI_Tools)

EOF
}

# Returns the OS that the system is
# WIP (only tested on Mac and Windows (Git Bash) )
os_finder() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "darwin_amd64"
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows_amd64"
    elif [[ "$OSTYPE" == "msys" ]]; then
        echo "windows_amd64"
    elif [[ "$OSTYPE" == "win32" ]]; then
        echo "win32"
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        echo "freebsd"
    else
        echo "Unknown OS, exiting..."
        exit 1
    fi
}

# Returns the download link that contains the SHA562 sums
# Parameters: $1 = Binary Name; $2 = Version; $3 OS name
binary_download_verify_link() {
    if [ "$formatted" == "terraform" ]; then
        echo "https://releases.hashicorp.com/terraform/${2}/terraform_${2}_SHA256SUMS"
    fi
}

# Returns the download link to the right version of the binary that we want to dowload.
# Parameters: $1 = Binary Name; $2 = Version; $3 OS name
binary_download_link() {
    if [ "$formatted" == "terraform" ]; then
        echo "https://releases.hashicorp.com/terraform/${2}/terraform_${2}_${3}.zip"
    fi
}

# Verifies the binary that was downloaded
# Parameters: $1 = Binary Name; $2 = Version; $3 = OS Name; $4 downloaded filename
verify_binary() {
    echo "Verifying binary download..."

    download_verify_link=$(binary_download_verify_link $1 $2 $3)
    verify_filename=$(echo ${download_verify_link##*/})
    verify_exit_code=$(curl -w '%{http_code}\n' -sLO "$download_verify_link")

    if [ "$verify_exit_code" != "200" ]; then
        echo "Can't seem to verify the binary downloaded. Proceed still? (yes - no)"
        read userInput
        
        if [ "${userInput}" != "yes" ]; then
            echo "Did not receive explicit yes, leaving script..."
            rm -f $4
            rm -f $verify_filename
            exit 0
        fi
    fi

    shasum_to_check=$(cat $verify_filename | grep $3 | cut -d ' ' -f 1)
    filename_shasum=$(shasum -a 256 $4 | cut -d ' ' -f 1)
    if [ "$filename_shasum" == "$shasum_to_check" ]; then
        echo "Binary file verifed sucessfully!"
        echo
        rm -f $verify_filename
    else
        echo "Binary NOT valid! Removing downloaded binary from system and exiting script..."
        rm -f $4
        rm -f $verify_filename
        exit 1
    fi
}

# Downloads the specific binary that was passed into this method
# Parameters: $1 = Binary Name; $2 = Version
download_binary() {
    formatted=$(echo $1 | awk '{print tolower($1)}')
    current_os=$(os_finder)

    echo "Downloading ${formatted}_${2}, please hold..."

    if [ -f "$MAIN_BINARY_PATH/${formatted}_${2}" ]; then 
        echo "${formatted}_${2} already exists! You can switch to it using configure.sh!"
        exit 1;
    elif [ ! -d "$MAIN_BINARY_PATH" ]; then
        echo "It appears $MAIN_BINARY_PATH does not exist, will create it automatically."
        mkdir -p $MAIN_BINARY_PATH
        echo
    fi

    download_link=$(binary_download_link $formatted $2 $current_os)
    filename=$(echo ${download_link##*/})
    exit_code=$(curl -w '%{http_code}\n' -sLO "$download_link")
    if [ "$exit_code" != "200" ]; then
        echo "Error, the download failed! Check to see if the download link is valid?"
        echo "Download link used: $download_link"
        rm -f "$filename"
        exit 1
    fi
    echo "Download complete!"
    echo
    
    verify_binary $formatted $2 $current_os $filename

    unzip -q $filename
    mv $formatted $MAIN_BINARY_PATH/${formatted}_${2}
    rm -f $filename

    echo "Sucessfully placed ${formatted}_${2} in $MAIN_BINARY_PATH. You can start using it by running the following command:"
    echo
    echo "    ./configure.sh -b ${formatted}_${2}"
    echo
    echo "Just makes sure $MAIN_BINARY_PATH is in your PATH variable!"
    echo
}

### Main
while getopts 'd:p:v:h' option; do
    case "$option" in
        d)
            BINARY_NAME=("$OPTARG")
            ;;
        p)
            MAIN_BINARY_PATH=("$OPTARG")
            echo "Specified specific path for binary path! Will be using $MAIN_BINARY_PATH now."
            ;;
        v)
            VERSION=("$OPTARG")
            ;;
        h) 
            usage
            exit 0
            ;;
        \?) 
            printf "illegal option: -%s\n" "$OPTARG" >&2
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND - 1))

if [[ -z $BINARY_NAME || -z $VERSION ]]; then
    echo "Did not specify needed flags, please specify them!"
    exit 1
fi

download_binary $BINARY_NAME $VERSION