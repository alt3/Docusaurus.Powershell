---
id: ci-cd
title: Continuous Integration/Deployment
sidebar_label: CI/CD
---

You might want to consider automating the process for generating the Get-Help pages
by hooking into your CI/CD workflow. This way you can be sure that your website
documentation will always be in-sync with the Get-Help code as found in your module.

As can be seen in this sample script,
auto-generating the pages is pretty straightforward and can easily be applied
to specific solutions for Azure Pipelines, Github Actions, Travis, etc.

```powershell
<#
    .SYNOPSIS
    Generates the MDX files used for your website's "Command Reference" pages.

    .NOTES
    Uses your latest module version unless a specific -ModuleVersion is provided.
#>
param (
  [Parameter(Mandatory = $True)][string] $Module,
  [Parameter(Mandatory = $False)][string] $ModuleVersion
)
Set-StrictMode -Version Latest
$PSDefaultParameterValues['*:ErrorAction'] = "Stop"

Write-Host "Generating MDX files for website Command Reference pages" -BackgroundColor DarkGreen

# -----------------------------------------------------------------------------
# Fetch module versions from PSGallery
# -----------------------------------------------------------------------------
$modules = @{}

Write-Host "Fetching module versions from PSGallery..."
if ($ModuleVersion) {
  $modules.$Module = $ModuleVersion
} else {
  $modules.$Module = (Find-Module -Name $Module).Version
}

$modules."Alt3.Docusaurus.PowerShell" = (Find-Module -Name Alt3.Docusaurus.PowerShell).Version
$modules.PlatyPS = (Find-Module -Name PlatyPS).Version

# -----------------------------------------------------------------------------
# Install required modules
# -----------------------------------------------------------------------------
$modules.GetEnumerator() | ForEach-Object {
  Write-Host "Requires $($_.Name) $($_.Value)"

  if ((Get-Module -ListAvailable $_.Name).Version -contains $_.Value) {
    Write-Host "=> already installed"
  } else {
    Write-Host "=> installing"
    Install-Module $_.Name -RequiredVersion $_.Value -Force -SkipPublisherCheck -AllowClobber -Scope CurrentUser
  }

  Write-Host "=> importing"
  Import-Module -Name $_.Name -RequiredVersion $_.Value -Force
}

# -----------------------------------------------------------------------------
# Use below settings to manipulate the rendered MDX files
# -----------------------------------------------------------------------------
$docusaurusOptions = @{
  Module          = $Module
  DocsFolder      = "./docs"
  SideBar         = "commands"
  EditUrl         = "null" # prevent the `Edit this Page` button from appearing
  Exclude         = @(
    "Get-DummyFunction"
  )
  MetaDescription = 'Help page for the "%1" command'
  MetaKeywords    = @(
    "PowerShell"
    "Help"
    "Documentation"
  )
  AppendMarkdown = "## EDIT THIS PAGE`nThis page was auto-generated using the comment based help in $($Module) $($modules.$Module)."
}

# -----------------------------------------------------------------------------
# Generate the new MDX files
# -----------------------------------------------------------------------------
Push-Location $PSScriptRoot
Write-Host (Get-Location)

Write-Host "Removing existing MDX files" -ForegroundColor Magenta
$outputFolder = Join-Path -Path $docusaurusOptions.DocsFolder -ChildPath $docusaurusOptions.Sidebar | Join-Path -ChildPath "*.*"
if (Test-Path -Path $outputFolder) {
  Remove-Item -Path $outputFolder
}

Write-Host "Generating new MDX files" -ForegroundColor Magenta
New-DocusaurusHelp @docusaurusOptions

Write-Host "Render completed successfully" -BackgroundColor DarkGreen
Pop-Location
```
