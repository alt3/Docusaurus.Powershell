function SetMarkdownFrontMatter() {
    <#
        .SYNOPSIS
            Replaces PlatyPS generated front matter with Docusaurus compatible front matter.

        .LINK
            https://www.apharmony.com/software-sagacity/2014/08/multi-line-regular-expression-replace-in-powershell/
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $False)][string]$CustomEditUrl
    )

    $powershellCommandName = [System.IO.Path]::GetFileNameWithoutExtension($markdownFile.Name)

    # prepare front matter
    $newFrontMatter = [System.Collections.ArrayList]::new()
    $newFrontMatter.Add("---") | Out-Null
    $newFrontMatter.Add("id: $($powershellCommandName)") | Out-Null
    $newFrontMatter.Add("title: $($powershellCommandName)") | Out-Null
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
