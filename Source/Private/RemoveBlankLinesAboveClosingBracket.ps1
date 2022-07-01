function RemoveBlankLinesAboveClosingBracket() {
    <#
        .SYNOPSIS
            Removes blank lines ABOVE lines ending with a closing curly bracket.

        .NOTES
            Required so following steps can trust formatting.

        .LINK
            https://regex101.com/r/jMBHcT/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose "Removing blank lines above closing curly bracket"

    $content = ReadFile -MarkdownFile $MarkdownFile

    $regex = [regex]::new('(\n\n+\s+}|\n\n})')

    $content = $content -replace $regex, "`n}"

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
