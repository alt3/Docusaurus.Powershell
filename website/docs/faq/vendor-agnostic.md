---
id: vendor-agnostic
title: Vendor Agnostic
description: If you do not want to use Docusaurus, the Alt.Docusaurus.PowerShell module can also produce vendor agnostic output.
---

No matter how much we :heart: Docusaurus, we realize it will not be the right solution for everyone as users might:

- prefer different (non-javascript) languages
- need to maintain an existing solution
- simply not like the green lizard

## TL;DR

I want the markdown produced by this module **but I do not want to use Docusaurus**.

```powershell
New-DocusaurusHelp -Module "YourModule" -VendorAgnostic
```

## How Does It Work?

By passing the `-VendorAgnostic` switch parameter this module will generate the exact same
markdown as always but will skip two Docusaurs-specific steps during the process:

1. front matter
2. Docusaurus sidebar file

### Front Matter

The PlatyPS generated markdown front matter:

- will not be touched
- will need to updated/replaced (by you) to fit your needs
- will look similar to the example below

```yml
---
external help file: Alt3.Docusaurus.PowerShell-help.xml
Module Name: Alt3.Docusaurus.PowerShell
online version: https://docusaurus-powershell.netlify.app/
schema: 2.0.0
---
```

### Docusaurus Sidebar File

The Docusaurus-specific `docusaurus.sidebar.js` file will not be generated.

If your solution/vendor requires a similar list you will need to generate one yourself,
perhaps using the
[NewSideBarIncludeFile](https://github.com/alt3/Docusaurus.PowerShell/blob/master/Source/Private/NewSidebarIncludeFile.ps1)
function for inspiration.

## Additional Information

- Get-Help documentation for the [-VendorAgnostic](../commands/New-DocusaurusHelp#-vendoragnostic) switch parameter
