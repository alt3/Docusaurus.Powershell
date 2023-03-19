function HtmlEncodeGreaterThanBrackets() {
    <#
        .SYNOPSIS
            Html encode platyPS generated `\>` brackets (except inside codeblocks).

        .LINK
            https://regex101.com/r/T14SYa/1

        .LINK
            https://regex101.com/r/bI0yGB/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )


    $content = ReadFile -MarkdownFile $MarkdownFile

    $i = 0
    [bool]$codeblock = $False

    foreach($line in $content) {
        if ($line -match '```' -and $codeblock -eq $False) {
            $codeblock = $True
        } elseif ($line -match '```' -and $codeblock -eq $True) {
            $codeBlock = $False
        }

        if ($codeblock -eq $False) {
            $line = [regex]::replace($line, '([a-zA-Z]:)\\\>', '$1\\&gt;') # something special for C:\>
            $line = [regex]::replace($line, '\\\>', '&gt;')

            $content[$i] = $line
        }

        if ($codeblock -eq $True) {
            $content[$i] = [regex]::replace($line, '(?<![a-zA-Z|\`]:)\\\>', '>')
        }

        $i++
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
