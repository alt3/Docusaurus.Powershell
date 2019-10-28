---
id: multiple-modules
title: Multiple Modules
---

You can document as many modules as you like by using the `-Sidebar` switch parameter.

For example, the following commands would generate module documentation for
both `ModuleA` and `ModuleB`, each contained within their own sidebar subfolder.

```
New-DocusaurusHelp -Module "ModuleA" -Sidebar "SidebarA" -EditUrl "http://some.url"
New-DocusaurusHelp -Module "ModuleB" -Sidebar "SidebarB" -EditUrl "http://some.url"
```

Would also require updating `docusaurus/sidebars.js` to include both sidebar specifications.

```js
const moduleA = require('./docs/ModuleA/docusaurus.sidebar.js');
const moduleB = require('./docs/ModuleB/docusaurus.sidebar.js');

module.exports = {
  docs: {
    Docusaurus: ['doc1', 'doc2', 'doc3'],
    ModuleA: moduleA,
    ModuleB: moduleB,
  },
};
```
