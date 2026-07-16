[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Scope = "Function")]
param()

function Test-InlineCodeCurlyBrackets {
    <#
        .SYNOPSIS
            Dummy module to ensure curly brackets inside inline code are not escaped (https://github.com/alt3/Docusaurus.Powershell/issues/180).

        .DESCRIPTION
            Curly brackets must be escaped for MDX except inside code, so:

            - raw {curly} brackets should be escaped
            - inline code like `@{ Splat = $true }` and `${variable}` should not be touched
            - code blocks should not be touched

        .EXAMPLE
            Invoke-Something -Splat `@{ Key = 'value' }`

            The hashtable `@{ Path = $file; Recurse = $true }` should render without backslashes.

            This raw {curly} bracket should be escaped and so should {{ this double one }}.

            ```
            $fenced = @{ Untouched = $true }
            ```

            Trailing text with `{ inline }` and raw {brackets} on the same line.
    #>
    [CmdletBinding()]
    param()
}
