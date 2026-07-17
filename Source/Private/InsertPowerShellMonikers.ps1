function InsertPowerShellMonikers() {
    <#
        .SYNOPSIS
            Adds the `powershell` moniker to the code blocks in the SYNTAX section.

        .NOTES
            We need to do this because PlatyPS does not add the moniker to the syntax
            code blocks itself. Only the SYNTAX section is processed because all other
            (user authored) code blocks should be left untouched.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $regexSyntaxSection = [regex]'(?s)## SYNTAX.*?(?=\n## )'

    $content = $regexSyntaxSection.Replace($content, {
        param($match)

        $regexBareFencedBlock = [regex]'(```)\n((?:(?!```)[\s\S])+)(```)'
        $regexBareFencedBlock.Replace($match.Value, '```powershell' + "`n" + '$2```')
    }, 1)

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
