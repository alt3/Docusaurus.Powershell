function RemoveContentHeader1() {
    <#
        .SYNOPSIS
        Removes the H1 element from the markdown content because Docusaurus already generates H1 using the `title` front matter.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = [System.IO.File]::ReadAllText($MarkdownFile)

    $regex = '\n#{1}\s.+\n'

    $content = [regex]::replace($content, $regex, '')

    # replace file content (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($markdownFile.FullName, $content, $fileEncoding)
}
