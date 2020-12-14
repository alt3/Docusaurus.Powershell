---
id: monolithic-modules
title: Monolithic Modules
---

Powershell Modules come in two forms:

- **monolithic**, where a single `.psm1` source file contains all module functions
- **non-monolithic**, where each module function is contained in a dedicated `.ps1` source file

By default, Docusaurus.Powershell assumes that you are documenting a non-monolithic module and
will therefore generate `Edit this page` URLs pointing to individual `.ps1` source files.

Users documenting monolithic modules should use the `-Monolithic` switch parameter to ensure
that all `Edit this page` URLs will point to the same `.psm1` source file.

> **Please note** that this will only apply if you are using the [-EditUrl](../commands/New-DocusaurusHelp#-editurl) switch parameter.
