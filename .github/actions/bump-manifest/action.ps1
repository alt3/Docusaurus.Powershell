<#
    .SYNOPSIS
    Replaces module manifest on master with bumped manifest in the artifact, then creates the commit.
#>
[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true)][string]$ArtifactPath,
    [Parameter(Mandatory=$true)][string]$Module
)

# some debugging

Get-ChildItem

git branch -a

Write-Output "================================================================================"
Write-Output "PSD1 on master:"
Write-Output "=> module          = $Module"
$masterManifest = Join-Path -Path "Source" -ChildPath "$Module.psd1"
Write-Output "=> master manifest = $masterManifest"
Get-Content $masterManifest

Write-Output "================================================================================"
Write-Output "PSD1 in artifact:"
Write-Output "=> artifact path    = $ArtifactPath"
$artifactVersion = (Get-ChildItem $ArtifactPath -Directory | Sort-Object | Select-Object -Last 1).Name
Write-Output "=> artifact version = $artifactVersion"
$artifactManifest = Join-Path $ArtifactPath -ChildPath $artifactVersion | Join-Path -ChildPath "$Module.psd1"
Write-Output "=> artifact manifest = $artifactManifest"

Get-Content $artifactManifest


