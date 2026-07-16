function RemoveSectionPlaceholders() {
    <#
        .SYNOPSIS
            Removes PlatyPS generated placeholders from the INPUTS, OUTPUTS, NOTES and
            RELATED LINKS sections, leaving the (required) section headings empty instead.

        .NOTES
            The SYNOPSIS and DESCRIPTION placeholders are kept because they remind
            module authors to complete their Get-Help definitions.

        .NOTES
            The INPUTS and OUTPUTS placeholders are removed because PlatyPS also
            generates them for comment-based help that DOES describe the type (Get-Help
            returns the entire .INPUTS/.OUTPUTS text as the type name, leaving the
            description PlatyPS looks at empty).
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $content = $content -replace '\n\{\{ Fill in the (Notes|related links here) \}\}\n?', ''

    # remove the type description placeholders in the INPUTS and OUTPUTS sections only
    $regexInputsOutputsSections = [regex]'(?s)## INPUTS.*?(?=\n## NOTES)'

    $content = $regexInputsOutputsSections.Replace($content, {
        param($match)

        return $match.Value -replace '\n\{\{ Fill in the Description \}\}\n?', ''
    }, 1)

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
