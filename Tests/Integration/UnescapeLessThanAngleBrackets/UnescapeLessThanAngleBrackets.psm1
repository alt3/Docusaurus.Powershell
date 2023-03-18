function Test-UnescapeLessThanAngleBrackets {
    <#
        .SYNOPSIS
            Dummy module to ensure platyPS `&lt;` opening angle brackets are unescaped properly.

        .EXAMPLE
            All lines should be unescaped.

            \<
            \<test
            \< test
            test \<
            test \< again
    #>
}
