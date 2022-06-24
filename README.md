[![Build](https://github.com/alt3/Docusaurus.PowerShell/actions/workflows/main.yml/badge.svg)](https://github.com/alt3/Docusaurus.PowerShell/actions/workflows/main.yml)
[![Netlify](https://img.shields.io/netlify/0f0b21b3-3caf-40a6-aaf8-4bc926523a0f?label=Netlify&style=flat-square)](https://app.netlify.app/sites/docusaurus-powershell/deploys/5da9a382df61220008fb04c0)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/Alt3.Docusaurus.PowerShell?style=flat-square)](https://www.powershellgallery.com/packages/Alt3.Docusaurus.PowerShell)
[![Azure DevOps coverage](https://img.shields.io/azure-devops/coverage/alt3bv/Docusaurus.PowerShell/3?style=flat-square)](https://dev.azure.com/alt3bv/Docusaurus.PowerShell/_build)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg?style=flat-square)](https://www.contributor-covenant.org/version/2/0/code_of_conduct)

# Docusaurus.PowerShell

Documentation websites for PowerShell Modules (with auto-generated Get-Help pages).

## Live Demo

[https://docusaurus-powershell.netlify.app](https://docusaurus-powershell.netlify.app)

## Screenshot

![Screenshot](website/static/img/screenshot.png "Screenshot")

## Who's Using This?

<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://pester.dev/"><img src="https://raw.githubusercontent.com/pester/Pester/master/images/logo.png" width="100px;" alt=""/><br /><h3>Pester</h3></td>
  </tr>
</table>

## Local Development

PowerShell 7, Pester 4:

- `cd /local/path/to/repo`
- `./Install-RequiredModules.s1`
- `dev/build-and-import-module.ps1`
- `Invoke-Pester`

> **Important:** after code changes, make sure to build-and-import the Alt3 module before running Pester!
