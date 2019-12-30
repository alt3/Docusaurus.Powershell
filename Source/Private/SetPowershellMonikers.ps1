function SetPowershellMonikers() {
    <#
        .SYNOPSIS
            Add `powershell` moniker to generated code blocks for correct syntax highlighting.

        .NOTES
            Unfortunately we need to do this because PlatyPS does not add the language (design choice)
            => https://github.com/PowerShell/platyPS/issues/475
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    # this regex replaces all opening code fences without a language moniker with "```powershell"
    # https://regex101.com/r/AYzALd/1
    $regex = '(```)\n((?:(?!```)[\s\S])+)(```)\n'

    $content = [regex]::replace($content, $regex, '```powershell' + "`n" + '$2```' + "`n")

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
