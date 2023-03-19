function Test-HtmlEncodeGreaterThanBrackets {
    <#
        .SYNOPSIS
            Dummy module to ensure proper html encoding of platyPS opening (>) and closing (<) brackets.

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
            test C:\>
            test C:\> again
            ```

            encode\>
            encode \>
            encode\>this

            ```
            d:\>
            test d:\>
            test d:\> again
            ```

            This <line> should be html encoded.
    #>
}
