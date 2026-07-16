function RemoveSectionPlaceholders() {
    <#
        .SYNOPSIS
            Removes PlatyPS generated placeholders from the NOTES and RELATED LINKS
            sections, leaving the (required) section headings empty instead.

        .NOTES
            The SYNOPSIS and DESCRIPTION placeholders are kept because they remind
            module authors to complete their Get-Help definitions.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $content = $content -replace '\n\{\{ Fill in the (Notes|related links here) \}\}\n?', ''

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
