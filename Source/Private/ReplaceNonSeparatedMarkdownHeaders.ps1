function ReplaceNonSeparatedMarkdownHeaders() {
    <#
        .SYNOPSIS
            Adds an empty line after markdown headers IF they are directly followed by an adjacent non-empty lines.

        .NOTES
            This ensures the markdown format will match with e.g. Prettier which in turn will
            prevent getting format-change suggestions when running e.g. > Visual Studio Code
            > CTRL+SHIFT+P > Format Document.

        .LINK
            https://regex101.com/r/Gsd3PX/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    Write-Verbose "Inserting empty line beneath non-separated headers."

    $content = ReadFile -MarkdownFile $MarkdownFile

    $regex = [regex]::new('(?m)([#+].+)\n(.+)')

    $content = $content -replace $regex, ('$1' + "`n`n" + '$2')

    # replace file
    WriteFileContent -MarkdownFile $MarkdownFile -Content $content
}
