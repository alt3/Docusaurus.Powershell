function RemoveMarkdownHeaderOne() {
    <#
        .SYNOPSIS
        Removes the H1 element from the markdown content because Docusaurus already generates H1 using the `title` front matter.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    $regex = '\n#{1}\s.+'

    $content = [regex]::replace($content, $regex, '')

    # replace file
    WriteFileContent -MarkdownFile $MarkdownFile -Content $content
}
