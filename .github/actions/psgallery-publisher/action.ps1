<#
    .SYNOPSIS
    Publishes a module to the Powershell Gallery.
#>
Set-StrictMode -Version Latest
$PSDefaultParameterValues['*:ErrorAction'] = "Stop" # full script stop on first error

# Make sure the secret key PSGALLERY_API_KEY is set
if (-not $env:INPUT_APIKEY) {
    Throw "Secret key PSGALLERY_API_KEY has not been set"
}

# Publish the module
Write-Host "Publishing modulePath = $($env:INPUT_MODULEPATH)"
Publish-Module -Path $env:INPUT_MODULEPATH -NuGetApiKey $env:INPUT_APIKEY -Verbose -WhatIf
