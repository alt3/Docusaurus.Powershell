function Test-UnescapeInlineCode {
    <#
        .SYNOPSIS
            Dummy module to ensure proper unescaping of `<angle brackets>` inside inline code.

        .NOTES
            Replaces platyPS escaped `\<` and `\>` with `<` and `>`.

            Please note that platyPS escaped '&bsol;&bsol;&bsol;&gt;' is not preserved when
            importing the file content. This means there is no way we can support '&bsol;&gt;'
            inside inline code.

        .PARAMETER Dummy
            Dummy `<parameter>` with multiple `<inline code>`.

        .EXAMPLE
            IMPORTANT: Platy will remove this first-line example code completely if you use a bracket here.

            `<inlinecode>`

            `<inlinecode>` should remain unescaped

            Text with`<inlinecode>`should remain unescaped

            Text with `<inlinecode>` should remain unescaped

            Multiple occurences should all remain unescaped

            `<inlinecode1>``<inlinecode2>`

            `<inlinecode1>` `<inlinecode2>`

            `<inlinecode1>` `<inlinecode2>` with trailing text

            With leading text `<inlinecode1>` `<inlinecode2>`

            With leading text `<inlinecode1>` and `<inlinecode2>`

            With leading text `<inlinecode1>` and `<inlinecode2>` with trailing text

            `<inlinecode1>` `<inlinecode2>` `<inlinecode3>` `<inlinecode4>`

            `<inlinecode1><inlinecode2>`
            `<inlinecode1> <inlinecode2> trailing`
            `leading <inlinecode1> <inlinecode2>`
            `boxed <inlinecode1> <inlinecode2> boxed`
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string] $Dummy
    )

    Write-Output $Dummy
}
