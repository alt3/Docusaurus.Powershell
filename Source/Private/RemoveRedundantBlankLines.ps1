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

    foreach($line in $content) {
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
