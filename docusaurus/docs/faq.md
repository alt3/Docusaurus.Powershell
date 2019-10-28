---
id: faq
title: F.A.Q.
---

## Does this support multiple modules?

Yes, you can integrate as many modules as you like by using the `-Sidebar` switch parameter.

For example, run the following commands to generate module documentation for
both `ModuleA` and `ModuleB`, each contained within their own sidebar subfolder.

```
New-DocusaurusHelp -Module "ModuleA" -Sidebar "SidebarA" -EditUrl "http://some.url"
New-DocusaurusHelp -Module "ModuleB" -Sidebar "SidebarB" -EditUrl "http://some.url"
```

Then update `docusaurus/sidebars.js` to include both auto-generated sidebar specifications.

```js
const moduleA = require('./docs/ModuleA/docusaurus.sidebar.js');
const moduleB = require('./docs/ModuleB/docusaurus.sidebar.js');

module.exports = {
  docs: {
    Docusaurus: ['doc1', 'doc2', 'doc3'],
    Features: ['mdx'],
    ModuleA: moduleA,
    ModuleB: moduleB,
  },
};
```

## What does the -Monolithic switch do?

Powershell Modules come in two forms:

- **monolithic**, where one `.psm1` source file contains all functions
- **non-monolithic**, where multiple `.ps1` source files are compiled into a single `.psm1`

The `-Monolithic` switch is used to determine the URLs for the `Edit this page` links which:

- will always point to the same `.psm1` source file for monolithic modules
- will point to the corresponding `.ps1` source file for non-monolithic modules

> **Note:** Using this switch is only required if you are documenting a monolithic module.

