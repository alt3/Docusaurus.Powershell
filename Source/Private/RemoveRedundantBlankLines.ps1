function RemoveRedundantBlankLines() {
    <#
        .SYNOPSIS
            Collapses consecutive blank lines (outside code blocks) into a single blank line.

        .NOTES
            Blank lines inside code blocks are left untouched because they are part of the
            user authored example code.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    $newContent = [System.Collections.Generic.List[string]]::new()
    [bool]$codeblock = $False
    [bool]$previousLineBlank = $False
    [bool]$frontmatter = $content[0] -eq '---'
    $i = 0

    foreach($line in $content) {
        # skip the front matter, blank lines inside multi-line yaml values are data
        if ($frontmatter) {
            if ($i -gt 0 -and $line -eq '---') {
                $frontmatter = $False
            }

            $i++
            $newContent.Add($line)
            continue
        }
        $i++

        if ($line -match '```') {
            $codeblock = -not $codeblock
        }

        $lineBlank = [string]::IsNullOrWhiteSpace($line)

        if (-not $codeblock -and $lineBlank -and $previousLineBlank) {
            continue
        }

        $previousLineBlank = $lineBlank
        $newContent.Add($line)
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $newContent
}
