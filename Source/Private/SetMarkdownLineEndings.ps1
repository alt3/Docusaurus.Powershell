function SetMarkdownLineEndings() {
    <#
        .SYNOPSIS
            Replaces all CRLF line endings with LF so we can consitently use/expect `n when regexing etc.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = (Get-Content -Path $MarkdownFile.FullName -Raw).TrimEnd()

    $content = ($content -replace "`r`n", "`n") + "`n"

    # replace file
    WriteFileContent -MarkdownFile $MarkdownFile -Content $content
}
