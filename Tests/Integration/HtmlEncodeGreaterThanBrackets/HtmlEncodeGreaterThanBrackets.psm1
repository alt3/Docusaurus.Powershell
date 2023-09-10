[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Scope = "Function")]
param()
function Test-HtmlEncodeGreaterThanBrackets {
    <#
        .SYNOPSIS
            Dummy module to ensure proper html encoding of platyPS escaped '>' angle brackets (except inside code blocks).

        .NOTES
            Invoke-DummyModule -Configuration \<PesterConfiguration\> [\<CommonParameters\>]

        .PARAMETER Dummy
            Should encode  parameter with 'numbers <A> and B>'

        .EXAMPLE
            IMPORTANT: Platy will remove this first-line example code completely if you use a bracket here.

            \>

            \> should be encoded

            \>should be encoded

            ```
            C:\>
            unencoded C:\>
            unencoded C:\> again
            ```

            C:\>

            C:\> encoded with backslash

            encoded C:\> with backslash

            encoded\>

            encoded \>

            encoded\>too

            ```
            d:\>
            unencoded d:\>
            unencoded d:\> again
            ```

            This <line> should be html encoded.
    #>
}
