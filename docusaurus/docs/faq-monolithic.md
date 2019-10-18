---
id: faq-monolithic
title: Monolithic
---

Powershell Modules come in two forms:

- **monolithic** where one `.psm1` source file contains all functions
- **non-monolithic** where multiple `.ps1` source files are compiled into a single `.psm1`

`Docusaurus.Powershell` will seamlessly generate documentation for both forms but
assumes, by default, that you are following industry best practices and are thus using
non-monolithic sources.

> If you are documenting a monolithic module make sure to pass the `-Monolithic` parameter
> so the correct Docusaurus `editUrl` will be generated.

## editUrl

Each help page comes with an `Edit this page` link using the URL specified by
the `editUrl` front matter variable inside the corresponding `.mdx` file.

Because we are documenting Get-Help the links point directly to the Powershell source files and thus:

- to a single `.ps1` source file for non-monolithcic modules
- the `.psm1` source file for monolitic modules

## Pro Tip

If you are interested in creating proper non-monolithic modules take a look at
[Module Builder]().

## External information

- [Designing your Powershell Module for Maintainability](https://devblackops.io/designing-your-powershell-module-for-maintainability/)
- [Docusaurus Front Matter Variables](https://v2.docusaurus.io/docs/markdown-features/#markdown-headers)
