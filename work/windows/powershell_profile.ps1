# Disable Sounds
Set-PSReadlineOption -BellStyle None

# https://dev.to/animo/fish-like-autosuggestion-in-powershell-21ec
# Autosuggestions in Powerline
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Dracula theme: https://draculatheme.com/powershell
# Dracula readline configuration. Requires version 2.0, if you have 1.2 convert to `Set-PSReadlineOption -TokenType`
Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::Green
    "Parameter" = [ConsoleColor]::Gray
    "Operator" = [ConsoleColor]::Magenta
    "Variable" = [ConsoleColor]::White
    "String" = [ConsoleColor]::Yellow
    "Number" = [ConsoleColor]::Blue
    "Type" = [ConsoleColor]::Cyan
    "Comment" = [ConsoleColor]::DarkCyan
}

# Prevent commands with spaces in front to record in history 
# https://superuser.com/a/1767011
Set-PSReadLineOption -AddToHistoryHandler {
    param($command)
    if ($command -like ' *') {
        return $false
    }
    return $true
} 


# Dracula Prompt Configuration
Import-Module posh-git
$GitPromptSettings.DefaultPromptPrefix.Text = "$([char]0x2192) " # arrow unicode symbol
$GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Green
$GitPromptSettings.DefaultPromptPath.ForegroundColor =[ConsoleColor]::Cyan
$GitPromptSettings.DefaultPromptSuffix.Text = "$([char]0x203A) " # chevron unicode symbol
$GitPromptSettings.DefaultPromptSuffix.ForegroundColor = [ConsoleColor]::DarkYellow

$GitPromptSettings.DefaultPromptPrefix.Text = '$(Get-Date -f "MM-dd HH:mm") '
$GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::DarkMagenta
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
$GitPromptSettings.DefaultPromptAbbreviateGitDirectory = $true

# Dracula Git Status Configuration
$GitPromptSettings.BeforeStatus.ForegroundColor = [ConsoleColor]::Blue
$GitPromptSettings.BranchColor.ForegroundColor = [ConsoleColor]::Blue
$GitPromptSettings.AfterStatus.ForegroundColor = [ConsoleColor]::Blue

# Functions
function GDB() {
    # Gets the default branch in a repo
    $result = git symbolic-ref refs/remotes/origin/HEAD
    $result = $result.replace("refs/remotes/origin/","")
    $result
}

# New Aliases
Set-Alias -Name ".." -Value "cd.."
Set-Alias -name "python" -Value "py"
Set-Alias -name "sudo" -Value "gsudo"
Set-Alias -name "code" -Value "codium"

# Due to alias not getting properly validated in Cmder, we need to control which ones we want to use here
Set-Alias -Name "terraform" -Value "C:\Users\Matthew.Shiroma\.bin\terraform_1_13_4.exe"
Set-Alias -Name "packer" -Value "C:\Users\Matthew.Shiroma\.bin\packer_1_14_2.exe"

# Sets up Powershell to use UTF-8 Encoding
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Adding specific paths to PATH (these are NOT permenant; these are specific to the specific shell)
# This is done because we mostly use Git Bash; this path is already added to it
$env:Path += ";C:\Users\Matthew.Shiroma\.bin"

