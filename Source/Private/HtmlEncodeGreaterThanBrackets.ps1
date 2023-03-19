function HtmlEncodeGreaterThanBrackets() {
    <#
        .SYNOPSIS
            Html encode platyPS generated `\>` brackets (except inside codeblocks).

        .LINK
            https://regex101.com/r/T14SYa/1
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
            $content[$i] = [regex]::replace($line, '\\\>', '&gt;')
        }

        if ($codeblock -eq $True) {
            $content[$i] = [regex]::replace($line, '(?<![a-zA-Z|\`]:)\\\>', '>')
        }

        $i++
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
