function RemoveMarkdownHeaderOne() {
    <#
        .SYNOPSIS
        Removes the H1 element from the markdown content because Docusaurus already generates H1 using the `title` front matter.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = (Get-Content -Path $MarkdownFile.FullName -Raw).TrimEnd()

    $regex = '\n#{1}\s.+\n\r'

    $newContent = [regex]::replace($content, $regex, '')

    # replace file (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($markdownFile.FullName, $newContent, $fileEncoding)
}
