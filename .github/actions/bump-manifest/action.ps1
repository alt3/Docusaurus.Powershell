<#
    .SYNOPSIS
    Updates version number in module manifest, then creates a commit to master.

    .NOTES
    Expects a git clone of master branch with full history in subfolder `_master`.
#>
[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true)][string]$Path,
    [Parameter(Mandatory=$true)][string]$Version
)

Write-Output "Bumping manifest version using:"
Write-Output "Path    = $Path"
Write-Output "Version = $Version"

Set-Location $Path

Write-Output "Path content:"
Get-ChildItem

Get-Content .\Source\Alt3.Docusaurus.Powershell.psd1


