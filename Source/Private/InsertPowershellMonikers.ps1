function InsertPowerShellMonikers() {
    <#
        .SYNOPSIS
            Adds the `powershell` moniker to all code blocks without a language moniker.

        .NOTES
            We need to do this because PlatyPS does (yet) not add the moniker itself
            => https://github.com/PowerShell/platyPS/issues/475

        .LINK
            https://regex101.com/r/Jpo9AL/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    $regex = '(```)\n((?:(?!```)[\s\S])+)(```)\n'

    $content = [regex]::replace($content, $regex, '```powershell' + "`n" + '$2```' + "`n")

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
