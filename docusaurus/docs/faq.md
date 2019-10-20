---
id: faq
title: F.A.Q.
---

## What does the -Monolithic switch do?

Powershell Modules come in two forms:

- **monolithic**, where one `.psm1` source file contains all functions
- **non-monolithic**, where multiple `.ps1` source files are compiled into a single `.psm1`

The `-Monolithic` switch is used to determine the URLs for the `Edit this page` links which:

- will always point to the same `.psm1` source file for monolithic modules
- will point to the corresponding `.ps1` source file for non-monolithic modules

> **Note:** Using this switch is only required if you are documenting a monolithic module.
