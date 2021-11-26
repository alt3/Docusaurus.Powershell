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

# construct some variables
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

$commitMessage = "Bump manifest to $artifactVersion [no-release]"
Write-Output "=> commit message    = $commitMessage"

$artifactManifest = Get-Item -Path $artifactManifestPath
$masterManifest = Get-Item -Path $masterManifestPath

# replace manifest
Write-Output "================================================================================"
Write-Output "Replacing manifest on master:"
Copy-Item -Path $artifactManifest -Destination $masterManifest -Force -Verbose
Write-Output "Updated manifest on master:"
Get-Content -Path $masterManifest.FullName

# commit the change
Write-Output "================================================================================"
Write-Output "Preparing Git commit:"

Set-Location $MasterFolder -Verbose

git branch -a
git status
git remote -v
git config --global core.safecrlf false # prevent CRLF/LF warnings stopping the pipeline
git config --global --core

git add $masterManifest.FullName
git commit -m $commitMessage
git status

# git remote remove origin
# git remote add origin "https://$($env:MAPPED_GITHUB_USERNAME):$($env:MAPPED_GITHUB_PERSONAL_ACCESS_TOKEN)@github.com/$($env:BUILD_REPOSITORY_ID).git"
# git config --global core.safecrlf false # prevent CRLF/LF warnings stopping the pipeline
# git config --global user.name $env:MAPPED_GITHUB_USERNAME
# git config --global user.email "$($env:MAPPED_GITHUB_USERNAME)@users.noreply.github.com"

# git remote -v
# git config --global --list

Write-Output "Git Commit Updated Manifest:"
# git add "Source/$env:ARTIFACT_MANIFEST_NAME"
# git commit -m $commitMessage
# git push origin master --quiet
