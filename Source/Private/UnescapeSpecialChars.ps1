function UnescapeSpecialChars() {
    <#
        .SYNOPSIS
            Replaces platyPS escaped special chars with the un-escaped version.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    # regular
    $content = [regex]::replace($content, '\\`', '`') # backticks: `
    $content = [regex]::replace($content, '\\\[', '[') # square opening brackets: [
    $content = [regex]::replace($content, '\\\]', ']') # square closing brackets: ]

    # specific cases
    $content = [regex]::replace($content, '\\\\\\>', '\>') # as used in eg: PS C:\>

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
