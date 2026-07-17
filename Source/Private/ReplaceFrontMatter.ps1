function ReplaceFrontMatter() {
    <#
        .SYNOPSIS
            Replaces PlatyPS generated front matter with Docusaurus compatible front matter.

        .DESCRIPTION
            The PlatyPS-native front matter keys are removed and replaced with the
            Docusaurus front matter variables this module generates.

            All other keys are preserved as-is which allows users to enrich the front
            matter themselves (e.g. by adding a `description` key to `CommandHelp.Metadata`
            before passing the objects to `New-DocusaurusHelp -CommandHelp`). Preserved
            keys always win over the values this module would generate, so e.g. an
            existing `description` key is not overwritten by `-MetaDescription`.

        .LINK
            https://github.com/alt3/Docusaurus.Powershell/issues/185
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $False)][string]$CustomEditUrl,
        [Parameter(Mandatory = $False)][string]$MetaDescription,
        [Parameter(Mandatory = $False)][array]$MetaKeywords,
        [switch]$HideTitle,
        [switch]$HideTableOfContents
    )

    $powershellCommandName = [System.IO.Path]::GetFileNameWithoutExtension($markdownFile.Name)

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    # ---------------------------------------------------------------------
    # parse the existing front matter into (multi-line) entries, keyed by
    # their top-level yaml key
    # ---------------------------------------------------------------------
    $regexFrontMatter = [regex]"(?sm)^(---)(.+?)^(---).$\n"
    $existingEntries = [ordered]@{ }

    $match = $regexFrontMatter.Match($content)
    if ($match.Success) {
        $currentKey = $null

        foreach ($line in ($match.Groups[2].Value.Trim([char]10) -split "`n")) {
            if ($line -match '^(?<key>[A-Za-z][A-Za-z0-9_. -]*):') {
                $currentKey = $Matches.key
                $existingEntries[$currentKey] = $line
            } elseif ($null -ne $currentKey -and $line -match '^\s+\S') {
                $existingEntries[$currentKey] += "`n$line" # multi-line value (e.g. a list)
            }
        }
    }

    # remove the PlatyPS-native keys (all other keys are user-enriched and thus preserved)
    @('document type', 'external help file', 'HelpUri', 'Locale', 'Module Name', 'ms.date', 'PlatyPS schema version') | ForEach-Object {
        $existingEntries.Remove($_)
    }

    # also remove the PlatyPS-native title (but preserve user-customized titles)
    if ("$($existingEntries['title'])" -match "^title:\s*$([regex]::Escape($powershellCommandName))\s*$") {
        $existingEntries.Remove('title')
    }

    # ---------------------------------------------------------------------
    # prepare new front matter, preserved keys win over generated values
    # ---------------------------------------------------------------------
    $newFrontMatter = [System.Collections.ArrayList]::new()
    $newFrontMatter.Add("---") | Out-Null

    $addEntry = {
        param($key, $generatedEntry)

        if ($existingEntries.Contains($key)) {
            $newFrontMatter.Add($existingEntries[$key]) | Out-Null
            $existingEntries.Remove($key)
        } elseif ($null -ne $generatedEntry) {
            $newFrontMatter.Add($generatedEntry) | Out-Null
        }
    }

    & $addEntry 'id' "id: $($powershellCommandName)"
    & $addEntry 'title' "title: $($powershellCommandName)"

    $description = $null
    if ($MetaDescription) {
        $description = "description: $([regex]::replace($MetaDescription, '%1', $powershellCommandName))"
    }
    & $addEntry 'description' $description

    $keywords = $null
    if ($MetaKeywords) {
        $keywords = "keywords:`n" + (($MetaKeywords | ForEach-Object { "  - $($_)" }) -join "`n")
    }
    & $addEntry 'keywords' $keywords

    & $addEntry 'hide_title' "hide_title: $(if ($HideTitle) {"true"} else {"false"})"
    & $addEntry 'hide_table_of_contents' "hide_table_of_contents: $(if ($HideTableOfContents) {"true"} else {"false"})"

    $editUrl = $null
    if ($CustomEditUrl) {
        $editUrl = "custom_edit_url: $($CustomEditUrl)"
    }
    & $addEntry 'custom_edit_url' $editUrl

    # append remaining user-enriched keys
    foreach ($entry in $existingEntries.Values) {
        $newFrontMatter.Add($entry) | Out-Null
    }

    $newFrontMatter.Add("---") | Out-Null

    # translate front matter to a string and replace CRLF with LF
    $newFrontMatter = ($newFrontMatter | Out-String) -replace "`r`n", "`n"

    # replace front matter
    $content = $regexFrontMatter.Replace($content, $newFrontMatter, 1)

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
