function UnescapeInlineCode() {
    <#
        .SYNOPSIS
            Unescapes special characters inside single backtick `inline code`.

        .NOTES
            Please note that platyPS generated `\\\>` is not preserved when importing the
            file content. This means we have no way to support `\>` inside inline code.

        .LINK
            https://regex101.com/r/80DpiH/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )


    $content = ReadFile -MarkdownFile $MarkdownFile

    $i = 0
    [bool]$codeblock = $False

    foreach ($line in $content) {
        if ($line -match '```' -and $codeblock -eq $False) {
            $codeblock = $True
        }
        elseif ($line -match '```' -and $codeblock -eq $True) {
            $codeBlock = $False
        }

        if ($codeblock -eq $True) {
            $i++
            continue # do nothing when inside a codeblock
        }

        $regex = [regex]::new('\`[^`].*?\`')

        if (-not($line -match $regex)) {
            $i++
            continue
        }

        # Process < brackets first
        $inlineCodes = $regex.Matches($line)

        $inlineCodes  | Foreach-Object {
            $inlineCode = $_.Value

            $newInlineCode = $inlineCode

            # we first unescape all < brackets
            if (-not($newInlineCode -match '\\\\\\\<')) {
                $newInlineCode = $newInlineCode -replace ('\\\<', '<')
                $line = $line.replace($inlineCode, $newInlineCode)
            }

            # remaining escaped < must be part of the inline code content (and thus not escaped)
            if ($newInlineCode -match '\\\\\\\<') {
                $newInlineCode = $newInlineCode -replace ('\\\\\\\<', '\<KEEP')
                $line = $line.replace($inlineCode, $newInlineCode)
            }
        }

        $line = $line.replace('\<KEEP', '\<')

        $content[$i] = $line.replace('\>', '>') # see .NOTES

        $i++
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
