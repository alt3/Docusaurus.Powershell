[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Scope = "Function")]
param()
function Test-HtmlEncodeLessThanBrackets {
    <#
        .SYNOPSIS
            Dummy module to ensure proper html encoding of platyPS escaped opening '<' angle brackets (except inside code blocks).

        .NOTES
            Invoke-DummyModule -Configuration \<PesterConfiguration\> [\<CommonParameters\>]

        .PARAMETER Dummy
            Should encode  parameter with 'numbers <A> and B>'

        .EXAMPLE
            IMPORTANT: Platy will remove this first-line example code completely if you use a bracket here.

            \<
            \<test should be encoded
            \< test should be encode

            ```
            \<
            \<unencoded
            \< unencoded
            \<unencoded\<
            ```

            encode \<
            encode\<
            encode\<this

            ```
            unencoded \< unencoded
            ```

            This <example> should also be <encoded>.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string] $Dummy
    )

    Write-Output $Dummy
}
