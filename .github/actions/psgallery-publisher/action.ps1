<#
    .SYNOPSIS
    Publishes a module to the Powershell Gallery.
#>
[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true)][string]$ModulePath
)

Set-StrictMode -Version Latest
$PSDefaultParameterValues['*:ErrorAction'] = "Stop" # full script stop on first error

# Debug current directory
Get-ChildItem

# Debug the module path
Write-Host "D:"
Get-ChildItem -Path "D:"

Write-Host "D:\a"
Get-ChildItem -Path "D:\a"

Write-Host "D:\a\Docusaurus.Powershell:"
Get-ChildItem -Path "D:\a\Docusaurus.Powershell"

Write-Host "D:\a\Docusaurus.Powershell\Docusaurus.Powershell:"
Get-ChildItem -Path "D:\a\Docusaurus.Powershell\Docusaurus.Powershell"

# Make sure the secret key PSGALLERY_API_KEY is set
if (-not $env:PSGALLERY_API_KEY) {
    Throw "Github secret PSGALLERY_API_KEY has not been set"
}

# Find path to the module version
Write-Host "Module path = $ModulePath"
$moduleVersion = (Get-ChildItem $ModulePath -Directory | Sort-Object | Select-Object -Last 1).Name
Write-Host "Module version = $moduleVersion"

# Publish the module
Write-Host "Publishing modulePath = $ModulePath"
Publish-Module -Path (Join-Path -Path $ModulePath -ChildPath $moduleVersion) -NuGetApiKey $env:PSGALLERY_API_KEY -Verbose -WhatIf
