<#
    .SYNOPSIS
    Replaces module manifest on main with bumped manifest in the artifact, then creates the commit.

    .PARAMETER ArtifactFolder
    Path to the artifact holding the newly built module (e.g. Modules/Alt3.Docusaurus.Powershell)

    .PARAMETER MainFolder
    Path to the main repo (e.g. __main)
#>
[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true)][string]$ArtifactFolder,
    [Parameter(Mandatory=$true)][string]$MainFolder
)

# prepare variables
Write-Output "========================================================================================================================"
Write-Output "=> artifact folder   = $ArtifactFolder"
Write-Output "=> main folder       = $MainFolder"

$moduleName = $env:MODULE_NAME
Write-Output "=> module name       = $moduleName"

$artifactVersion = (Get-ChildItem $ArtifactFolder -Directory | Sort-Object | Select-Object -Last 1).Name
Write-Output "=> artifact version  = $moduleName"

$artifactManifestPath = Join-Path $ArtifactFolder -ChildPath $artifactVersion | Join-Path -ChildPath "$moduleName.psd1"
Write-Output "=> artifact manifest = $artifactManifestPath"

$mainManifestPath = Join-Path $MainFolder -ChildPath "Source" | Join-Path -ChildPath "$moduleName.psd1"
Write-Output "=> main manifest     = $mainManifestPath"

$commitMessage = "Bump manifest to $artifactVersion"
Write-Output "=> commit message    = $commitMessage"

$artifactManifest = Get-Item -Path $artifactManifestPath -Verbose
$mainManifest = Get-Item -Path $mainManifestPath -Verbose

Write-Output "========================================================================================================================"
Write-Output "Replacing manifest on main:"
Copy-Item -Path $artifactManifest -Destination $mainManifest -Force -Verbose
Write-Output "Updated manifest on main:"
Get-Content -Path $mainManifest.FullName

Write-Output "========================================================================================================================"
Write-Output "Switch working directory"
Set-Location $MainFolder -Verbose

Write-Output "========================================================================================================================"
Write-Output "Preparing Git commit:"
Write-Output "=> actor = $($env:GITHUB_ACTOR)"
Write-Output "=> repo  = $($env:GITHUB_REPOSITORY)"
$email  = "$($env:GITHUB_ACTOR)@users.noreply.github.com"
Write-Output "=> email = $email"

Write-Output "Git branches:"
git branch -a

Write-Output "Configure remote and config:"
git remote remove origin
git remote add origin "https://$($env:GITHUB_ACTOR):$($env:GITHUB_TOKEN)@github.com/$($env:GITHUB_REPOSITORY).git"
git config --global core.safecrlf false # prevent CRLF/LF warnings stopping the pipeline
git config --global user.name $env:GITHUB_ACTOR
git config --global user.email $email
git config --global --list

Write-Output "========================================================================================================================"
Write-Output "Git status:"
git status

Write-Output "========================================================================================================================"
Write-Output "Git commit:"
git add $mainManifest.FullName
git commit -m $commitMessage
git status

Write-Output "========================================================================================================================"
Write-Output "Git push:"
git push origin main --quiet
