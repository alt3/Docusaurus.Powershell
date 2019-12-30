function SetMarkdownLineEndings() {
    <#
        .SYNOPSIS
            Replaces all CRLF line endings with LF so we can consitently use/expect `n when regexing etc.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    $content = ($content -replace "`r`n", "`n") + "`n"

    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
