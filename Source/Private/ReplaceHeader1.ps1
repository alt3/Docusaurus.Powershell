function ReplaceHeader1() {
    <#
        .SYNOPSIS
            Removes the markdown H1 element OR preprends it with an extra newline if the -KeepHeader1 switch is used.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [switch]$KeepHeader1
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    $regex = '(---)\n(# .+)'

    if ($KeepHeader1) {
        $content = $content -replace $regex, ("---`n`n" + '$2') # prepend newline (for first match only)
    } else {
        $content = $content -replace $regex, '---' # remove line (for first match only)
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
