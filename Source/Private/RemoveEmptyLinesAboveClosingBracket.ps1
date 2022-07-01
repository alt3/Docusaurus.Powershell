function RemoveEmptyLinesAboveClosingBracket() {
    <#
        .SYNOPSIS
            Removes empty lines below lines ending with a closing curly bracket.

        .NOTES
            Required so following steps can trust formatting.

        .LINK
            https://regex101.com/r/xvEd2O/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose "Removing empty lines above closing curly bracket"

    $content = ReadFile -MarkdownFile $MarkdownFile

    $regex = [regex]::new('(\n\n+\s+}|\n\n})')

    $content = $content -replace $regex, "`n}"

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
