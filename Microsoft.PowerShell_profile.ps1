# ahh yes... this would be so nice if it was a built in variable
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# load all script modules available to us
Get-Module -ListAvailable | ? { $_.ModuleType -eq "Script" } |   Import-Module
# function loader
#
# if you want to add functions you can add scripts to your
# powershell profile functions directory or you can inline them
# in this file. Ignoring the dot source of any tests
Resolve-Path $here\functions\*.ps1 | 
? { -not ($_.ProviderPath.Contains(".Tests.")) } |
% { . $_.ProviderPath }

set-alias npp "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe"

# inline functions, aliases and variables
function sls_search ($str, $filePattern = "*.*") { dir -r -include $filePattern  | select-string $str}
function gs {git status --short @args}
function gb {git branch @args} 
function gt {git tag @args} 
function gil {git lol @args} 
function gdt {git difftool @args}
function rm-rf($item) { Remove-Item $item -Recurse -Force }
function touch($file) { (dir $file).LastWriteTime = get-date }
function purgeCache() {ls -r -include web.config | % {touch $_}} 
function openProject() {ii *.sln; ii .}

$UserBinDir = "$($env:UserProfile)\bin"

# PATH update
#
# creates paths to every subdirectory of userprofile\bin
$paths = @("$($env:Path)")
gci $UserBinDir | % { $paths += $_.FullName }
$env:Path = [String]::Join(";", $paths) 


$sqlListTables ="SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'"
function shorten-path([string] $path) { 
   $loc = $path.Replace($HOME, '~') 
   # remove prefix for UNC paths 
   $loc = $loc -replace '^[^:]+::', '' 
   # make path shorter like tabs in Vim, 
   # handle paths starting with \\ and . correctly 
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2') 
}

function prompt {
    write-Host(shorten-path (pwd).Path) -nonewline -foregroundcolor gray
	if (isCurrentDirectoryGitRepository) {
		$shortSha =  git log -1 --format="%h"
		Write-Host(" [") -nonewline -foregroundcolor yellow
		Write-Host($shortSha) -nonewline -foregroundcolor green
		Write-Host(" | ") -nonewline -foregroundcolor yellow
		$currentBranchName = gitBranchName
		Write-Host($currentBranchName) -nonewline -foregroundcolor green
		Write-Host("]") -nonewline -foregroundcolor yellow
	}
    return "> "
}
New-Alias which get-command
. (Resolve-Path ~/Documents/WindowsPowershell/ssh-agent-utils.ps1)
cmd /c """C:\Program Files `(x86`)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat""" ""x86""

cd C:\src
$env:Path += ";C:\Windows\SysWOW64"
