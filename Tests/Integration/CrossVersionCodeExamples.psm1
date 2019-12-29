function Test-CrossVersionCodeExamples {
<#
    .SYNOPSIS
        Dummy module to ensure all supported Get-Help example variations render identically on all Powershell versions.

    .LINK
        https://github.com/alt3/Docusaurus.Powershell/issues/14#issuecomment-568552556

    .EXAMPLE
        $exampleType = 'Native single-line example without description'

    .EXAMPLE
        $exampleType = 'Native single-line example with single-line description'

        Description starts on this line

    .EXAMPLE
        $exampleType = 'Native single-line example with non-adjacent multi-line description'

        Description starts on this line

        Description line 2

    .EXAMPLE
        $exampleType = 'Native single-line example with adjacent multi-line description'

        Description starts on this line
        Description line 2

    .EXAMPLE
        ```
        $exampleType = 'Code-fenced single-line example without description'
        ```

    .EXAMPLE
        ```
        $exampleType = 'Code-fenced single-line example with single-line description'
        ```

        Description starts on this line

    .EXAMPLE
        ```
        $exampleType = 'Code-fenced single-line example with non-adjacent multi-line description'
        ```

        Description starts on this line

        Description line 2

    .EXAMPLE
        ```
        $exampleType = 'Code-fenced single-line example with adjacent multi-line description'
        ```

        Description starts on this line
        Description line 2

    .EXAMPLE
        ```
        $exampleType = 'Complex non-adjacent code-fenced example without description'
        $names | Foreach-Object {} {
            write-host 'indentation is respected'
            Write-Host 'enormously long lines will not get cut off by our PlatyPS friends, ftw'
        }

        $multipleNewlinesInCode = $True
        ```

    .EXAMPLE
        ```
        $exampleType = 'Complex non-adjacent code-fenced example with a complex markdown description'
        $names | Foreach-Object {} {
            write-host 'indentation is respected'
            Write-Host 'enormously long lines should not get cut off by our PlatyPS friends, ftw'
        }

        $multipleNewlinesInCode = $True
        ```

        Description starts on this line

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
        $exampleType = 'Code-fenced single line example using POWERSHELL MONIKER without description'
        ```

    .EXAMPLE
        ```powershell
        $exampleType = 'Code-fenced single line example using POWERSHELL MONIKER with single-line description'
        ```

        Description starts on this line

    .EXAMPLE
        ```posh
        $exampleType = 'Code-fenced single line example using POSH MONIKER without description'
        ```

    .EXAMPLE
        ```posh
        $exampleType = 'Code-fenced single line example using POSH MONIKER with single-line description'
        ```

        Description starts on this line

    .EXAMPLE
        ```ps
        $exampleType = 'Code-fenced single line example using PS MONIKER without description'
        ```

    .EXAMPLE
        ```ps
        $exampleType = 'Code-fenced single line example using PS MONIKER with single-line description'
        ```

        Description starts on this line
#>
}
