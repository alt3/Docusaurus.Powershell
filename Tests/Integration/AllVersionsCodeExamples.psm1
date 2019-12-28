function Test-AllVersionsCodeExamples {
<#
    .SYNOPSIS
        Dummy module to ensure all supported Get-Help example variations render identically on all Powershell versions.

    .LINK
        https://github.com/alt3/Docusaurus.Powershell/issues/14#issuecomment-568552556

    .EXAMPLE
        $description = 'Native single-line example without description'

    .EXAMPLE
        $description = 'Native single-line example with single-line description'

        This is description line 1

    .EXAMPLE
        $description = 'Native single-line example with non-adjacent multi-line description'

        This is description line 1

        This is description line 2

    .EXAMPLE
        $description = 'Native single-line example with adjacent multi-line description'

        This is description line 1
        This is description line 2

    .EXAMPLE
        ```
        $description = 'Code-fenced single-line example without description'
        ```

    .EXAMPLE
        ```
        $description = 'Code-fenced single-line example with single-line description'
        ```

        This is description line 1

    .EXAMPLE
        ```
        $description = 'Code-fenced single-line example with non-adjacent multi-line description'
        ```

        This is description line 1

        This is description line 2

    .EXAMPLE
        ```
        $description = 'Code-fenced single-line example with adjacent multi-line description'
        ```

        This is description line 1
        This is description line 2

    .EXAMPLE
        ```
        $description = 'Complex code-fenced example without description'
        $names | Foreach-Object {} {
            write-host 'indentation is respected'
            Write-Host 'enormously long lines will not get cut off by our PlatyPS friends, ftw'
        }

        $multipleNewlinesInCode = $True
        ```

    .EXAMPLE
        ```
        $description = 'Complex code-fenced example with a complex markdown description'
        $names | Foreach-Object {} {
            write-host 'indentation is respected'
            Write-Host 'enormously long lines should not get cut off by our PlatyPS friends, ftw'
        }

        $multipleNewlinesInCode = $True
        ```

        The description would continue after first closing code fence.

        This solution:

        - respects indentation
        - will treat description as markdown
        - seems close to what comes natural

        With this solution, the description itself could even contain code blocks:

        ```js
        $var = docusaurus.New($config);
        ```

        Pretty cool and one could argue that the console becomes more readable too
        as you can now at least see where the code ends and the explanation begins

        ```
        $unMonicked = "this code block should stay unmonicked, in other words powershell should not be added"
            $indentationRespected = $True
        $theBadNews - "that PlatyPS seems to cut off this line if a . is detected, wtf"
        ```

    .EXAMPLE
        ```powershell
        $description = 'Code-fenced single line example using POWERSHELL MONIKER without description'
        ```

    .EXAMPLE
        ```powershell
        $description = 'Code-fenced single line example using POWERSHELL MONIKER with single-line description'
        ```

        This is description line 1

    .EXAMPLE
        ```posh
        $description = 'Code-fenced single line example using POSH MONIKER without description'
        ```

    .EXAMPLE
        ```posh
        $description = 'Code-fenced single line example using POSH MONIKER with single-line description'
        ```

        This is description line 1

    .EXAMPLE
        ```ps
        $description = 'Code-fenced single line example using PS MONIKER without description'
        ```

    .EXAMPLE
        ```ps
        $description = 'Code-fenced single line example using PS MONIKER with single-line description'
        ```

        This is description line 1
#>
}
