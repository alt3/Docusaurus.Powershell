---
id: usage
title: Usage
---

Adding Docusaurus to a Powershell Module project requires two steps:

1. Adding the Docusaurus website skeleton
2. Generating Get-Help documentation in `.mdx` file format


## Adding Docusaurus

Add the Docusaurus skeleton by running the following
command inside your project's root folder:

```
npx @docusaurus/init@next init docusaurus classic
```

Modify new file `docusaurus/sidebars.js`so it looks like:

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

## Generating Documentation

Generate Get-Help documentation for your Powershell Module by running:

```
New-DocusaurusHelp -Module YourModule -OutputFolder "docusaurus/docs" -EditUrl "http://dummy.for.now"
```

> Inside the `docusaurus/docs` folder, you should now see one `.mdx` file for each command
> exported by your Powershell Module.

## Starting the Website

Start the website by running the following command inside the `docusaurus` folder:

```powershell
yarn start
```
