---
id: multi-line-examples
title: Multi-Line Examples
sidebar_label: Multi-Line Examples
---

Powershell's Comment Based Help was originally designed for `.EXAMPLE` nodes containing:

- (only) a **single-line command**
- followed by the command's output and/or a description

```
.EXAMPLE

  Get-RealName -NickName "SomeNick"

  Yasmine
```

## Code Fence Detection

Unfortunately these single-line examples no longer suffice as authors are now creating advanced functions
which require **complex multi-lined code examples** to properly inform their end-users. Because Microsoft
does not (and cannot) support these use-cases, Docusaurus comes with `Code Fence Detection`,
allowing you to use common markdown code fences to indicate where your example code block
starts and where it ends.

A simple example would look similar to:

```
.EXAMPLE
    ```powershell
    $description = 'Code Fenced example with a description'
    $names | Foreach-Object {} {
        Write-Host 'Indentation and empty newlines within the fenced code block will be respected'
    }

    $multipleNewlinesInCode = $True
    ```

    Your description would start here and:

    - is treated as markdown
    - can also contain fenced code blocks
```

> For more usage examples see
> [this test module](https://github.com/alt3/Docusaurus.Powershell/blob/master/Tests/Integration/CrossVersionCodeExamples.psm1)
> and the corresponding [rendered markdown](https://github.com/alt3/Docusaurus.Powershell/blob/master/Tests/Integration/CrossVersionCodeExamples.expected.mdx)

**Please note** that you may use any of the following commonly used opening fences:

- \`\`\`
- \`\`\`powershell
- \`\`\`posh
- \`\`\`ps

## Powershell 7

Even though Powershell 7 ships with native support for multi-line code it only
does so in a limited form as can be seen in this example:

```
.EXAMPLE
    $description = 'Powershell 7+ multi-line example with a description'
    $description = 'ONLY Powershell 7 will consider all adjacent first lines to be code'
    $description = 'Code block ends (and description begins) at the first two newlines`

    Powershell 7 will use this line, and everything below it, as the description
```

**You could consider using it instead of Code Fence Detection if:**

- you are using Powershell 7
- your example code does not contain any empty newlines

## Default Fallback

Docusuarus.Powershell will fall back to using the unaltered PlatyPS generated code blocks
if code fencing is not detected.

This is intentional behavior and is done because:

- it would be impossible to "guess" where the code ends and the description begins
- we can redirect (and fix) bugs in the right place (PlatyPS repository)
- it will automatically support the multi-line examples that ships with Powershell 7

## Unexpected Results

If your example code is not being rendered as expected please make sure to understand why it is
not being recognized as multi-line code before creating an issue or pull request. Most likely,
updating your help to use Code Fence Detection would be the better alternative.

## Additional Information

- [Detailed description of the Docusaurus.Powershell determination process](https://github.com/alt3/Docusaurus.Powershell/issues/14#issuecomment-568552556)
- [Confirmation of Powershell 7 native multi-line code](https://github.com/PowerShell/platyPS/issues/180#issuecomment-568877700)
