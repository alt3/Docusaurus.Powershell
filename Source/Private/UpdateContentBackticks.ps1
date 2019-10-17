function UpdateContentBackticks() {
    <#
        .SYNOPSIS
        Replaces platyPS-produced "escaped backticks" with normal backticks so markdown gets rendered as expected.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = [System.IO.File]::ReadAllText($MarkdownFile)

    $regex = '\\`'

    $content = [regex]::replace($content, $regex, '`')

    # replace file content (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($markdownFile.FullName, $content, $fileEncoding)
}
