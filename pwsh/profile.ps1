# ---------------------------------------------------------------------
# C:\Users\<User>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# ---------------------------------------------------------------------

If (!$PROFILE.Contains("NuGet_profile")) {
	# powershell terminal
	Import-Module posh-git
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

	function GitStatus { git status }
	function CdDev { Set-Location -Path C:\dev }

	Set-Alias -Name d -Value CdDev

	Set-Alias -Name g -Value git
	Set-Alias -Name gs -Value GitStatus

	Set-Alias -Name l -Value eza
	Set-Alias -Name ls -Value eza
	Set-Alias -Name exa -Value eza

	Set-Location -Path C:\dev
}
Else {
	# Visual Studio - Package Manager Console
}


# ----------------------------------------------------------------------------------------------
# This profile for powershell core is OK with neovim lsp powershell
# CurrentUserCurrentHost: C:\Users\<User>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# ----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------
# Profile Location for powershell 5
# C:\Users\<User>\Documents\WindowsPowerShell\profile.ps1
# ----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------
# Profile Location for pwsh core
# ----------------------------------------------------------------------------------------------
# > echo $PROFILE
# > $PROFILE | Select-Object *Host* | Format-List
# AllUsersAllHosts: C:\Program Files\PowerShell\7\profile.ps1
# AllUsersCurrentHost: C:\Program Files\PowerShell\7\Microsoft.PowerShell_profile.ps1
# CurrentUserAllHosts: C:\Users\<User>\Documents\PowerShell\profile.ps1
# CurrentUserCurrentHost: C:\Users\<User>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# ----------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------
# Info
# ----------------------------------------------------------------------------------------------
# https://gist.github.com/shanselman/25f5550ad186189e0e68916c6d7f44c3
# https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/KeyBindings.cs
# https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/KeyBindings.vi.cs
# ----------------------------------------------------------------------------------------------
