function setCodeBlockLanguage() {
    <#
        .SYNOPSIS
        Add `powershell` syntax highlighting to generated code blocks.

        .NOTES
        1. unfortunately we need to do this because PlatyPS does not add the language (design choice)
        2. @todo change regex so it will match on \n as well (now only works on CRLF files)
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    # read file into a string, not an arry
    $content = [System.IO.File]::ReadAllText($MarkdownFile)

    # regex replace all code blocks without a language (test on https://regex101.com using /$regex/g)
    $regex = '(```)\r((?:(?!```)[\s\S])+)(```)\r'

    $content = [regex]::replace($content, $regex, '```powershell$2```')

    # replace file content (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($markdownFile.FullName, $content, $fileEncoding)
}
