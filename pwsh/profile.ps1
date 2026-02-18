# ---------------------------------------------------------------------
# C:\Users\<User>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# ---------------------------------------------------------------------

# Visual Studio - Package Manager Console
If ($PROFILE.Contains("NuGet_profile")) {
  return
}

# powershell terminal
Import-Module PSReadLine
Invoke-Expression (&starship init powershell)

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -EditMode Windows

Set-PSReadLineKeyHandler -Key Tab -Function Complete
# Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

Set-PSReadLineKeyHandler -Chord ctrl+p -Function PreviousHistory
Set-PSReadLineKeyHandler -Chord ctrl+n -Function NextHistory

# PowerShell parameter completion shim for the winget CLI
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
  dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# bat
$env:BAT_THEME = "Dracula"
$env:RIPGREP_CONFIG_PATH = "$HOME\.config\.ripgreprc"

# common aliases
function GitStatus { git status }
function CdDev { Set-Location -Path C:\dev }
function AlacrittyWindows { alacritty.exe --config-file "C:\Users\$env:USERNAME\AppData\Roaming\alacritty\alacritty-xl-win.toml" }

Set-Alias -Name d -Value CdDev
Set-Alias -Name g -Value git
Set-Alias -Name gs -Value GitStatus
Set-Alias -Name l -Value eza
Set-Alias -Name ls -Value eza
Set-Alias -Name exa -Value eza
Set-Alias -Name uu -Value coreutils
Set-Alias -Name helix -Value hx

# navigation bash like aliases
function CdUp {
  param ([int]$Levels = 1)
  for ($i = 0; $i -lt $Levels; $i++) {
    Set-Location ..
  }
}

function CdUp1 { CdUp -Levels 1 }
function CdUp2 { CdUp -Levels 2 }
function CdUp3 { CdUp -Levels 3 }
function CdUp4 { CdUp -Levels 4 }
function CdUp5 { CdUp -Levels 5 }

Set-Alias -Name .. -Value CdUp1
Set-Alias -Name ... -Value CdUp2
Set-Alias -Name .... -Value CdUp3
Set-Alias -Name ..... -Value CdUp4
Set-Alias -Name ...... -Value CdUp5

# delta aliases - paging does not work!
function delta-full {
  $input | delta --no-gitconfig --navigate --line-numbers --paging=always --syntax-theme=Dracula $args
}

function delta-split {
  $input | delta --no-gitconfig --navigate --line-numbers --side-by-side --paging=always --syntax-theme=Dracula $args
}

# set initial location
Set-Location -Path C:\dev

# ----------------------------------------------------------------------------------------------
# Lazy load modules
# ----------------------------------------------------------------------------------------------

$lazyModules = {
  # Import-Module mklink
  Import-Module posh-git
  Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })
}

# Use new PowerShell instance for background execution
$LazyLoader = [PowerShell]::Create()
[void]$LazyLoader.AddScript($lazyModules)

# Create a new runspace for background execution
$LazyRunspace = [RunspaceFactory]::CreateRunspace()
$LazyLoader.Runspace = $LazyRunspace
$LazyRunspace.Open()

# Start execution in the background
$LazyLoader.BeginInvoke() | Out-Null

# Register an event to clean up once the script completes
$null = Register-ObjectEvent -InputObject $LazyLoader -EventName InvocationStateChanged -Action {
  if ($LazyLoader.InvocationStateInfo.State -in @("Completed", "Failed", "Stopped")) {
    # If the script is finished, re-import the modules (in case needed)
    Invoke-Command -ScriptBlock $lazyModules

    $LazyLoader.Dispose()
    $LazyRunspace.Close()
    $LazyRunspace.Dispose()

    # TODO FIXME
    Get-Job | Where-Object { $_.State -ne "Completed" } | Remove-Job -Force
  }
}

# ----------------------------------------------------------------------------------------------
# Profile Locations for pwsh core
# ----------------------------------------------------------------------------------------------
# > echo $PROFILE
# > $PROFILE | Select-Object *Host* | Format-List
# ----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------
# This profile for powershell core is OK with neovim lsp powershell
# CurrentUserCurrentHost: C:\Users\<User>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# ----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------
# Profile Location for powershell 5
# C:\Users\<User>\Documents\WindowsPowerShell\profile.ps1
# ----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------
# Info
# ----------------------------------------------------------------------------------------------
# https://github.com/yavorski/PsMkLink
# ----------------------------------------------------------------------------------------------
# https://gist.github.com/shanselman/25f5550ad186189e0e68916c6d7f44c3
# https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/KeyBindings.cs
# https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/KeyBindings.vi.cs
# ----------------------------------------------------------------------------------------------
