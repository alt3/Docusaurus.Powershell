[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Scope = "Function")]
param()

function Test-CrossVersionCodeExamples {
<#
    .SYNOPSIS
        Dummy module to ensure all supported Get-Help example variations render identically on all PowerShell versions.

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

    .EXAMPLE
        ```ps
        $exampleType = 'This test-case is used to ensure proper un-escaping of "PlatyPS escaped special characters"'

        [bool]$string = 'These square brackets should display correctly'

        PS C:\> Get-ChildItem

        $multiline = "this is an example of multiline string using" `
                     "the backtick method"
        ```

        It should also unescape properly in the description and thus:

        - unescaped `backticks`
        - fully functioning [links](https://www.google.com)
        - use of the prompt directly: PS C:\> Get-ChildItem
        - use of the prompt backtick-enclosed: `PS C:\> Get-ChildItem`

    .EXAMPLE
        $exampleType = 'This test-case ensures that inserting a basic code example does not break the insert-powershell-moniker regex'

        Once seen during development where rendering Pester Mock.mdx would lead to this example containing parts of the example directly below.

    .EXAMPLE
        ```powershell
        # This test-case is used to ensure that:
        # - using hash (#) characters does not break the EXAMPLES extraction regex
        # - hash characters get rendered as expected (in both code and description)
        # - regexes that change markdown-headers do not touch anything else

        ######################################
        ## Even when someone goes all ASCII ##
        ######################################

        function PublicFunction {
            # Has a lot of hash characters
        }

        Export-ModuleMember -Function PublicFunction # comment

        # The test script:

        Import-Module MyModule
        ```

        # The description starts here, also contains a # character
        and is adjacent multi-line.

        ######################################################
        ## Another ASCII fan but now inside the description ##
        ######################################################

        .EXAMPLE
        "Input" | ForEach-Object {Show-Issue97 -Name $_}
#>
}
