<#
    .SYNOPSIS
    Replaces module manifest on master with bumped manifest in the artifact, then creates the commit.

    .PARAMETER ArtifactFolder
    Path to the artifact holding the newly built module (e.g. Modules/Alt3.Docusaurus.Powershell)

    .PARAMETER MasterFolder
    Path to the master repo (e.g. __master)
#>
[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true)][string]$ArtifactFolder,
    [Parameter(Mandatory=$true)][string]$MasterFolder
)

# construct the paths
Write-Output "================================================================================"
Write-Output "➡ artifact folder   = $ArtifactFolder"
Write-Output "➡ master folder     = $MasterFolder"

$moduleName = (Get-Item -Path $ArtifactFolder).Name
Write-Output "➡ module name       = $moduleName"

$artifactVersion = (Get-ChildItem $ArtifactFolder -Directory | Sort-Object | Select-Object -Last 1).Name
Write-Output "➡ artifact version  = $moduleName"

$artifactManifestPath = Join-Path $ArtifactFolder -ChildPath $artifactVersion | Join-Path -ChildPath "$moduleName.psd1"
Write-Output "➡ artifact manifest = $artifactManifestPath"

$masterManifestPath = Join-Path $MasterFolder -ChildPath "Source" | Join-Path -ChildPath "$moduleName.psd1"
Write-Output "♥ master manifest   = $masterManifestPath"

# some debugging

# Get-ChildItem
# Get-ChildItem Modules



# git branch -a

# Write-Output "================================================================================"
# Write-Output "PSD1 on master:"
# Write-Output "=> module          = $Module"
# $masterManifest = Join-Path -Path "Source" -ChildPath "$Module.psd1"
# Write-Output "=> master manifest = $masterManifest"
# Get-Content $masterManifest

# Write-Output "================================================================================"
# Write-Output "PSD1 in artifact:"
# Write-Output "=> artifact path    = $ArtifactFolder"
# $artifactVersion = (Get-ChildItem $ArtifactFolder -Directory | Sort-Object | Select-Object -Last 1).Name
# Write-Output "=> artifact version = $artifactVersion"
# $artifactManifest = Join-Path $ArtifactFolder -ChildPath $artifactVersion | Join-Path -ChildPath "$Module.psd1"
# Write-Output "=> artifact manifest = $artifactManifest"

# Get-Content $artifactManifest


