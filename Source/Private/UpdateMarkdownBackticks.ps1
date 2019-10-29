function UpdateMarkdownBackticks() {
    <#
        .SYNOPSIS
        Replaces platyPS-produced "escaped backticks" with normal backticks so markdown gets rendered as expected.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = (Get-Content -Path $MarkdownFile.FullName -Raw).TrimEnd()

    $regex = '\\`'

    $newContent = [regex]::replace($content, $regex, '`')

    # replace file (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($markdownFile.FullName, $newContent, $fileEncoding)
}
