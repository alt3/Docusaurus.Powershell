<#
    .SYNOPSIS
    Publishes a module to the Powershell Gallery.
#>
[cmdletbinding()]
Param(
    [string]$ModulePath
)
Set-StrictMode -Version Latest
$PSDefaultParameterValues['*:ErrorAction'] = "Stop" # full script stop on first error

# Make sure the secret key PSGALLERY_API_KEY is set
if (-not $env:PSGALLERY_API_KEY) {
    Throw "Secret key PSGALLERY_API_KEY has not been set"
}

# Publish the module
Write-Host "ModulePath = $ModulePath"
Publish-Module -Path $ModulePath -NuGetApiKey $env:PSGALLERY_API_KEY -Verbose -WhatIf
