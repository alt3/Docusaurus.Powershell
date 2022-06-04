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

# prepare variables
Write-Output "========================================================================================================================"
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

$commitMessage = "Bump manifest to $artifactVersion"
Write-Output "=> commit message    = $commitMessage"

$artifactManifest = Get-Item -Path $artifactManifestPath -Verbose
$masterManifest = Get-Item -Path $masterManifestPath -Verbose

Write-Output "========================================================================================================================"
Write-Output "Replacing manifest on master:"
Copy-Item -Path $artifactManifest -Destination $masterManifest -Force -Verbose
Write-Output "Updated manifest on master:"
Get-Content -Path $masterManifest.FullName

Write-Output "========================================================================================================================"
Write-Output "Switch working directory"
Set-Location $MasterFolder -Verbose

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
git add $masterManifest.FullName
git commit -m $commitMessage
git status

Write-Output "========================================================================================================================"
Write-Output "Git push:"
git push origin master --quiet
