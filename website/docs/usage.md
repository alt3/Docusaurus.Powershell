---
id: usage
title: Usage
---

Adding Docusaurus to a PowerShell Module project requires three steps:

1. Adding the Docusaurus website skeleton
2. Generating Module documentation
3. Starting the Website

## Adding Docusaurus

Open a PowerShell (Core).

Cd into your project's root folder.

Add the Docusaurus website skeleton by running:

```powershell
npx @docusaurus/init@next init docusaurus classic
```

Modify newly created file `docusaurus/sidebars.js` so it looks like this:

```js
const commands = require('./docs/commands/docusaurus.sidebar.js');

module.exports = {
  docs: {
    Docusaurus: ['doc1', 'doc2', 'doc3'],
    Features: ['mdx'],
    "Command Reference": commands
  },
};
```

## Generating Module Documentation

To generate Get-Help pages for any PowerShell module run the following command.

> For demo data, replace `YourModuleName` with e.g. `Microsoft.PowerShell.Management`

```powershell
New-DocusaurusHelp -Module "YourModuleName"
```

After the command has completed, the `docusaurus/docs/commands` folder
should contain one `.mdx` file for each command exported by the PowerShell module.

## Starting the Website

To start your website, cd into the `docusaurus` folder and run:

```powershell
yarn start
```
