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
which require **complex multi-lined code examples** to properly inform their end-users.

Because Microsoft
does not (and cannot) support these use-cases, Docusaurus comes with `Code Fence Detection`,
allowing you to use markdown code fences to indicate where your example code block starts
and where it ends.

Code fencing ensures identical rendering across all Powershell versions and looks similar to:

```
.EXAMPLE
    ```ps
    $description = 'Code Fenced example with a description'
    $names | Foreach-Object {} {
        Write-Host 'Indentation and empty newlines within the fenced code block will be respected'
    }

    $multipleNewlinesInCode = $True
    ```

    Your description would start here and:

    - is treated as markdown
    - could also contain fenced code blocks itself
```

**Please note** that you may use any of the following commonly used opening fences:

- \`\`\`
- \`\`\`ps
- \`\`\`posh
- \`\`\`powershell

> For a full list of usage examples see
> [this test module](https://github.com/alt3/Docusaurus.Powershell/blob/master/Tests/Integration/CrossVersionCodeExamples.psm1)
> and [the markdown](https://github.com/alt3/Docusaurus.Powershell/blob/master/Tests/Integration/CrossVersionCodeExamples.expected.mdx)
> it renders.

## Powershell 7 Native Multi-Lines

Even though Powershell 7 ships with
[native support for multi-line code examples](https://github.com/PowerShell/platyPS/issues/180#issuecomment-569119138)
it only supports a single use-case as can be seen in this example:

```
.EXAMPLE
    $exampleType = 'Powershell 7+ multi-line example with a description'
    $info = 'PS7 will treat all adjecent lines as code'
    $info = 'The code block will end at the first double-newline`

    PS7 will thus use this line, and everything below it, as the description
```

You could consider using PS7 multi-lines instead of Code Fence Detection if:

- you will (only) use Powershell 7 to generate your documentation
- your example code does not contain any empty lines

> Do not use native PS7 multi-lines if you intend to generate/test documentation using other Powershell versions!

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
