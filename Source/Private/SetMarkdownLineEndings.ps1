function SetMarkdownLineEndings() {
    <#
        .SYNOPSIS
            Replaces all CRLF line endings with LF so we can consitently use/expect `n when regexing etc.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = (Get-Content -Path $MarkdownFile.FullName -Raw).TrimEnd()

    $content = $content -replace "`r`n", "`n"

    # replace file (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($markdownFile.FullName, $content, $fileEncoding)
}
