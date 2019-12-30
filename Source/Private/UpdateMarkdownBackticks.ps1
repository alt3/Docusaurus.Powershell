function UpdateMarkdownBackticks() {
    <#
        .SYNOPSIS
        Replaces platyPS-produced "escaped backticks" with normal backticks so markdown gets rendered as expected.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    $regex = '\\`'

    $content = [regex]::replace($content, $regex, '`')

    # replace file
    WriteFileContent -MarkdownFile $MarkdownFile -Content $content
}
