function RepairRelatedLinks() {
    <#
        .SYNOPSIS
            Repairs PlatyPS generated RELATED LINKS so they render correctly.

        .DESCRIPTION
            PlatyPS renders `.LINK` help entries as markdown list items but:

            - bare urls produce a link without clickable text => `- [](url)`
            - text entries produce a link without a target => `- [text]()`

            This function uses the url as the link text for the first case and
            a plain text list item for the second case.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $regexRelatedLinksSection = [regex]'(?s)## RELATED LINKS.*$'

    $content = $regexRelatedLinksSection.Replace($content, {
        param($match)

        $section = [regex]::Replace($match.Value, '(?m)^- \[\]\((.+?)\)', '- [$1]($1)')
        $section = [regex]::Replace($section, '(?m)^- \[(.+?)\]\(\)', '- $1')

        return $section
    }, 1)

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
