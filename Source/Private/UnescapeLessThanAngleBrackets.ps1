function UnescapeLessThanAngleBrackets() {
    <#
        .SYNOPSIS
            Unescapes platyPS generated (&lt;) opening angle brackets.

        .LINK
            https://regex101.com/r/7kxcCp/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    $content = [regex]::replace($content, '(\\\\\\\<)', '<')

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
