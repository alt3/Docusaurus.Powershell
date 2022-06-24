function Test-PS7NativeMultiLineCode {
<#
    .SYNOPSIS
        Dummy module to test PowerShell 7 NATIVE multi-line code examples

    .LINK
        https://github.com/PowerShell/platyPS/issues/180#issuecomment-568877700

    .LINK
        https://github.com/PowerShell/PowerShell/pull/10776

    .EXAMPLE
        $exampleType = 'PowerShell 7 multi-line example WITHOUT a description'
            $respecsIndentation = $True

    .EXAMPLE
        $exampleType = 'PowerShell 7 multi-line example WITH a single-description'
            $respecsIndentation = $True

        PowerShell 7 will use this line, and everything below it, as the description

    .EXAMPLE
        $exampleType = 'PowerShell 7 multi-line example WITH a multi-line escription'
            $respecsIndentation = $True

        PowerShell 7 will use this line, and everything below it, as the description

        Description line 2
#>
}
