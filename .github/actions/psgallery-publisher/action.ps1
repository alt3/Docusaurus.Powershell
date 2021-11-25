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

# Make sure the secret key PSGALLERY_API_KEY is set
if (-not $env:PSGALLERY_API_KEY) {
    Throw "Github secret PSGALLERY_API_KEY has not been set"
}

# Construct path to the module version inside the artifact folder
Write-Output "Module path    = $ModulePath"
$moduleVersion = (Get-ChildItem $ModulePath -Directory | Sort-Object | Select-Object -Last 1).Name
Write-Output "Module version = $moduleVersion"
$fullPath = Join-Path -Path $ModulePath -ChildPath $moduleVersion
Write-Output "Full path      = $fullPath"

# Publish the module
Write-Output "Publish the module:"
Publish-Module -Path $fullPath -NuGetApiKey $env:PSGALLERY_API_KEY -Verbose -WhatIf
