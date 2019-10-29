function SetMarkdownFrontMatter() {
    <#
        .SYNOPSIS
            Replaces PlatyPS generated front matter with Docusaurus compatible front matter.

        .LINK
            https://www.apharmony.com/software-sagacity/2014/08/multi-line-regular-expression-replace-in-powershell/
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $True)][string]$CustomEditUrl
    )

    # prepare front matter
    $powershellCommandName = [System.IO.Path]::GetFileNameWithoutExtension($markdownFile.Name)

    $newFrontMatter = @(
        "---"
        "id: $powershellCommandName"
        "title: $powershellCommandName"
        "custom_edit_url: $customEditUrl"
        "---"
    ) | Out-String

    # replace front matter
    $content = (Get-Content -Path $MarkdownFile.FullName -Raw).TrimEnd()

    $regex = "(?sm)^(---)(.+)^(---).$\n"

    $newContent = $content -replace $regex, $newFrontMatter

    # replace file (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($markdownFile.FullName, $newContent, $fileEncoding)
}
