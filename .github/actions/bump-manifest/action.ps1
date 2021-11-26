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
Write-Output "=> artifact folder   = $ArtifactFolder"
Write-Output "=> master folder     = $MasterFolder"

$moduleName = $env:MODULE_NAME
Write-Output "=> module name       = $moduleName"

$artifactVersion = (Get-ChildItem $ArtifactFolder -Directory | Sort-Object | Select-Object -Last 1).Name
Write-Output "=> artifact version  = $moduleName"

$artifactManifestPath = Join-Path $ArtifactFolder -ChildPath $artifactVersion | Join-Path -ChildPath "$moduleName.psd1"
Write-Output "=> artifact manifest = $artifactManifestPath"

$masterManifestPath = Join-Path $MasterFolder -ChildPath "Source" | Join-Path -ChildPath "$moduleName.psd1"
Write-Output "=> master manifest   = $masterManifestPath"

$artifactManifest = Get-Item -Path $artifactManifestPath
$masterManifest = Get-Item -Path $masterManifestPath

# some debugging
Write-Output "================================================================================"
Write-Output "PSD1 on master BEFORE:"
Get-Content -Path $masterManifest.FullName

Write-Output "================================================================================"
Write-Output "PSD1 on artifact:"
Get-Content -Path $artifactManifest.FullName

Write-Output "================================================================================"
Copy-Item -Path $artifactManifest -Destination $masterManifest -Force
Write-Output "PSD1 on master AFTER:"
Get-Content -Path $masterManifest.FullName

# git branch -a
