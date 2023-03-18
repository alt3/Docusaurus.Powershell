function Test-UnescapeLessThanAngleBrackets {
    <#
        .SYNOPSIS
            Dummy module to ensure platyPS `&lt;` opening angle brackets are unescaped properly.

        .PARAMETER Dummy
            Pester code use e.g. parameter with the syntax 'Adds numbers <A> and <B>'

        .EXAMPLE
            The Dummy parameter description and all lines below should be unescaped.

            \<
            \<test
            \< test
            test \<
            test \< again
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string] $Dummy
    )
}
