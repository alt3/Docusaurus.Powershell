function SetMarkdownCodeBlockMoniker() {
    <#
        .SYNOPSIS
        Add `powershell` moniker to generated code blocks for correct syntax highlighting.

        .NOTES
        1. unfortunately we need to do this because PlatyPS does not add the language (design choice)
        2. @todo change regex so it will match on \n as well (now only works on CRLF files)
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = (Get-Content -Path $MarkdownFile.FullName -Raw).TrimEnd()

    # this regex replaces all opening code fences without a language moniker with "```powershell"
    # https://regex101.com/r/AYzALd/1
    $regex = '(```)\n((?:(?!```)[\s\S])+)(```)\n'

    $content = [regex]::replace($content, $regex, '```powershell' + "`n" + '$2```' + "`n")

    # replace file (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($markdownFile.FullName, $content, $fileEncoding)
}
