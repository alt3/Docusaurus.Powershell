<#
    .SYNOPSIS
    Creates a Github Release with release notes.

    .NOTES
    Also creates a single commit with bumped manifest version on master to make sure
    the master branch version is identical to the one published to the PSGallery.

    .NOTES
    Requires context `github.actor` and `github.token`
#>
[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true)][string]$ArtifactPath,
    [Parameter(Mandatory=$true)][string]$BumpedVersion
)

Set-StrictMode -Version Latest
$PSDefaultParameterValues['*:ErrorAction'] = "Stop" # full script stop on first error

# ===============================================================
# Construct path to the module version inside the artifact folder
# ===============================================================
Write-Output "Artifact path    = $ArtifactPath"
$artifactVersion = (Get-ChildItem $ArtifactPath -Directory | Sort-Object | Select-Object -Last 1).Name
Write-Output "Artifact version = $artifactVersion"
$fullPath = Join-Path -Path $ModulePath -ChildPath $artifactVersion
Write-Output "Module pat       = $fullPath"

# ===============================================================
# Create a commit the bumps the manifest version to match the
# version as was published to the PSGallery.
# IMPORTANT: committing the file to master will trigger another
# full Pipeline run but... because we are using the [no-release]
# commit message, the Publishing step will be skipped.
# ===============================================================
$commitMessage = "Bump manifest to $BumpedVersion [no-release]"
$gitFolder = $env:GITHUB_WORKSPACE
$gitSourceFolder = Join-Path -Path $gitFolder -ChildPath "Source"

Write-Output "Commit Message        = $commitMessage"
Write-Output "Updated Manifest Path = $env:ARTIFACT_MANIFEST_PATH"
Write-Output "Git Folder            = $gitFolder"
Write-Output "Git Source Folder     = $gitSourceFolder"

Write-Output "Files in Local Git Folder:"
Set-Location $gitFolder
Get-ChildItem

Write-Output "Files in Local Git Source Folder:"
Get-ChildItem -Path $gitSourceFolder

Write-Output "Replacing Manifest with Artifact Version:"
Copy-Item -Path $env:ARTIFACT_MANIFEST_PATH -Destination $gitSourceFolder

Write-Output "New Manifest Content:"
Get-Content (Join-Path -Path $gitSourceFolder -ChildPath $env:ARTIFACT_MANIFEST_NAME)

Write-Output "Configuring Git Repo:"
git checkout master
git remote remove origin
git remote add origin "https://$($env:MAPPED_GITHUB_USERNAME):$($env:MAPPED_GITHUB_PERSONAL_ACCESS_TOKEN)@github.com/$($env:BUILD_REPOSITORY_ID).git"
git config --global core.safecrlf false # prevent CRLF/LF warnings stopping the pipeline
git config --global user.name $env:MAPPED_GITHUB_USERNAME
git config --global user.email "$($env:MAPPED_GITHUB_USERNAME)@users.noreply.github.com"

Write-Output "Git Commit Updated Manifest:"
# git add "Source/$env:ARTIFACT_MANIFEST_NAME"
# git commit -m $commitMessage
# git push origin master --quiet
