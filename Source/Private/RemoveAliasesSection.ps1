function RemoveAliasesSection() {
    <#
        .SYNOPSIS
            Removes the PlatyPS generated ALIASES section when it only contains the
            `{{Insert list of aliases}}` placeholder.

        .NOTES
            ALIASES sections with real content (e.g. imported from user-enriched
            markdown or CommandHelp objects) are left untouched.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $regexAliasesSection = [regex]'\n## ALIASES\n[\s\S]*?(?=\n## )'

    $content = $regexAliasesSection.Replace($content, {
        param($match)

        if ($match.Value -match '{{Insert list of aliases}}') {
            return ''
        }

        return $match.Value
    }, 1)

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
