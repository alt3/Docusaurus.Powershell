function UnescapeClosingAngleBrackets() {
    <#
        .SYNOPSIS
            Replaces platyPS closing angle/greater-than brackets except Powershell prompts like `C:\>`.

        .LINK
            https://regex101.com/r/T14SYa/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    $content = [regex]::replace($content, '(?<![a-zA-Z]:)\\\>', '>')

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
