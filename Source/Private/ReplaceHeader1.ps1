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

    if ($KeepHeader1) {
        $regex = [regex]'\n#\s'
        $content = $regex.replace($content, "`n`n# ", 1) # prepend newline (for first match only)
    } else {
        $regex = [regex]'\n#{1}\s.+'
        $content = $regex.replace($content, '', 1) # remove line (for first match only)
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
