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
        $regex = '\n#\s'
        $content = $content -replace $regex, "`n`n# " # prepend newline
    } else {
        $regex = '\n#{1}\s.+'
        $content = [regex]::replace($content, $regex, '') # remove line
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
