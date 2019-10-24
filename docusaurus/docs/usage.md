---
id: usage
title: Usage
---

Adding Docusaurus to a Powershell Module project requires three steps:

1. Adding the Docusaurus website skeleton
2. Generating Module documentation
3. Starting the Website

## Adding Docusaurus

Open a Powershell (Core).

Cd into your project's root folder.

Add the Docusaurus website skeleton by running:

```powershell
npx @docusaurus/init@next init docusaurus classic
```

Modify newly created file `docusaurus/sidebars.js`so it looks like this:

```js
const cmdlets = require('./docs/docusaurus.powershell.sidebar.js');

module.exports = {
  docs: {
    Docusaurus: ['doc1', 'doc2', 'doc3'],
    Features: ['mdx'],
    CmdLets: cmdlets
  },
};
```

## Generating Module Documentation

Generate the documentation pages for your module by running:

```powershell
New-DocusaurusHelp -Module "YourModule" -OutputFolder "docusaurus/docs" -EditUrl "http://github.com/your/repo/sources"
```

> **Note:** after the command has completed, the `docusaurus/docs` folder
> should contain an `.mdx` file for each command exported by your Powershell module.

## Starting the Website

To start your website, cd into the `docusaurus` folder and run:

```powershell
yarn start
```
