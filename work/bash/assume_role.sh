#!/bin/bash

assumerole() {
    if [[ $# == 0 ]]; then
        echo ${AWSX_ASSUMED_ROLE:-'No role assumed via assume_role.sh'}
        return
    fi
    
    if [[ $1 == '--help' ]] || [[ $1 == '-h' ]]; then
        echo 'Usage: assumerole ARN_OR_PROFILE_NAME [SESSION_NAME]'
        return
    fi

    role=$1
    session_name=${2:-test-session}

    if [[ $role == arn:* ]]; then
        arn=$role
    else
        start_line=$(grep --line-number --max-count=1 "^\[profile $role\]" ~/.aws/config | cut -d: -f1)
        if [[ -z $start_line ]]; then
            echo "Profile $role not found in ~/.aws/config"
            return
        fi
        
        let start_line=$start_line+1
        end_line=$(grep --line-number --max-count=1 "^\[" <(tail -n +$start_line ~/.aws/config) | cut -d: -f1)
        
        if [[ -z $end_line ]]; then
            end_line=$(wc -l ~/.aws/config | cut -d' ' -f1)
        fi
        
        arn=$(grep --max-count=1 "^role_arn=" <(tail -n +$start_line ~/.aws/config | head -n $end_line) | cut -d= -f2)
        
        if [[ -z $arn ]]; then
            echo "No role_arn found in profile $role in ~/.aws/config"
            return
        fi
    fi
    
    data=$(aws sts assume-role --role-arn "$arn" --role-session-name "$session_name")
    if [[ $? -ne 0 ]]; then
	return  # aws sts should have written something to stderr in this case
    fi
    
    export AWS_ACCESS_KEY_ID=$(echo "$data" | jq -r .Credentials.AccessKeyId)
    export AWS_SECRET_ACCESS_KEY=$(echo "$data" | jq -r .Credentials.SecretAccessKey)
    export AWS_SESSION_TOKEN=$(echo "$data" | jq -r .Credentials.SessionToken)
    export AWSX_ASSUMED_ARN=$arn
    if [[ $role == arn:* ]]; then
        export AWSX_ASSUMED_ROLE=${arn#*role/}
    else
        export AWSX_ASSUMED_ROLE=$role
    fi
}

leaverole() {
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWSX_ASSUMED_ARN
    unset AWSX_ASSUMED_ROLE
}