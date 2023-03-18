function Test-UnescapeClosingAngleBrackets {
    <#
        .SYNOPSIS
            Dummy module to ensure platyPS escaped `greater-than` angle brackets are unescaped properly.

        .EXAMPLE
            First six lines should be unescaped, remaining lines with Powershell promtps should be untouched.

            \>
            \>test
            \> test
            test\>
            test \>
            test \> again
            C:\>
            test C:\>
            test C:\> again
            d:\>
            test d:\>
            test d:\> again
    #>
    }
