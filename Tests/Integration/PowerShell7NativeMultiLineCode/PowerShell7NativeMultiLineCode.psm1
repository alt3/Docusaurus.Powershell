function Test-PowerShell7NativeMultiLineCode {
    <#
        .SYNOPSIS
            Dummy module to test PowerShell 7 NATIVE multi-line code examples

        .DESCRIPTION
            Required because PlatyPS will not generate help for commands using an .EXAMPLE without a .DESCRIPTION.

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
