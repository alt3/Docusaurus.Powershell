function SetMarkdownFrontMatter() {
    <#
        .SYNOPSIS
            Replaces PlatyPS generated front matter with Docusaurus compatible front matter.

        .LINK
            https://www.apharmony.com/software-sagacity/2014/08/multi-line-regular-expression-replace-in-powershell/
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

    # prepare front matter
    $newFrontMatter = [System.Collections.ArrayList]::new()
    $newFrontMatter.Add("---") | Out-Null
    $newFrontMatter.Add("id: $($powershellCommandName)") | Out-Null
    $newFrontMatter.Add("title: $($powershellCommandName)") | Out-Null

    if ($MetaDescription) {
        $description = [regex]::replace($MetaDescription, '%1', $powershellCommandName)
        $newFrontMatter.Add("description: $($description)") | Out-Null
    }

    if ($MetaKeywords) {
        $newFrontMatter.Add("keywords:") | Out-Null
        $MetaKeywords | ForEach-Object {
            $newFrontMatter.Add("  - $($_)") | Out-Null
        }
    }
    $newFrontMatter.Add("hide_title: $(if ($HideTitle) {"true"} else {"false"})") | Out-Null
    $newFrontMatter.Add("hide_table_of_contents: $(if ($HideTableOfContents) {"true"} else {"false"})") | Out-Null

    if ($EditUrl) {
        $newFrontMatter.Add("custom_edit_url: $($EditUrl)") | Out-Null
    }

    $newFrontMatter.Add("---") | Out-Null

    # translate front matter to a string and replace CRLF with LF
    $newFrontMatter = ($newFrontMatter| Out-String) -replace "`r`n", "`n"

    # replace front matter
    $content = ReadFile -MarkdownFile $MarkdownFile
    $regex = "(?sm)^(---)(.+)^(---).$\n"
    $content = $content -replace $regex, $newFrontMatter

    # replace file
    WriteFileContent -MarkdownFile $MarkdownFile -Content $content
}
