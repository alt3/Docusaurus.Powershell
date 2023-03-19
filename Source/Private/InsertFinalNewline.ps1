function InsertFinalNewline() {
    <#
        .SYNOPSIS
            Adds a traling newline to the end of the file.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content ($content + "`n")
}
