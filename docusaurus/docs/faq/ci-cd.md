---
id: ci-cd
title: Continuous Integration/Deployment
sidebar_label: CI/CD
---

You might want to consider automating the process for generating the Get-Help pages
by hooking into your CI/CD workflow. This way you can be sure that your website
documentation will always be in-sync with the Get-Help code as found in your module.

As can be seen in this sample script (used for [Pester](https://pester.dev)),
auto-generating the pages is pretty straightforward so we will not describe
specific solutions for Azure Pipelines, Github Actions, Travis, etc.
Instead, simply mimic the script's behavior in your favorite ci/cd solution.

```powershell
Push-Location $PSScriptRoot
Write-Host (Get-Location)

Write-Host "Importing required modules" -ForegroundColor Magenta
Import-Module PlatyPS -NoClobber -Force
Import-Module Alt3.Docusaurus.Powershell -NoClobber -Force
Import-Module Pester -NoClobber -Force

$arguments = @{
  Module = "Pester"
  OutputFolder = "./docs"
  SideBar = "commands"
  Exclude = @(
    "Get-MockDynamicParameter"
    "Invoke-Mock"
    "SafeGetCommand"
    "Set-DynamicParameterVariable"
  )
  MetaDescription = 'Help page for the Powershell Pester "%1" command'
  MetaKeywords = @(
      "Powershell"
      "Pester"
      "Help"
      "Documentation"
  )
}

Write-Host "Removing existing files" -ForegroundColor Magenta
$outputFolder = Join-Path -Path $arguments.OutputFolder -ChildPath $arguments.Sidebar | Join-Path -ChildPath "*.*"
if (Test-Path -Path $outputFolder) {
  Remove-Item -Path $outputFolder
}

Write-Host "Generating Command Reference" -ForegroundColor Magenta
New-DocusaurusHelp @arguments

Pop-Location
```
