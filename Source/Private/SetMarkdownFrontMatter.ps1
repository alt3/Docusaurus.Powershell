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

    # replace front matter
    $content = (Get-Content -Path $MarkdownFile.FullName -Raw).TrimEnd()

    $regex = "(?sm)^(---)(.+)^(---).$\n"

    $newContent = $content -replace $regex, ($newFrontMatter | Out-String)

    # replace file (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($markdownFile.FullName, $newContent, $fileEncoding)
}
