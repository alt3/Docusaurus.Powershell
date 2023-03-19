function IndentLineBelowOpeningBracket() {
    <#
        .SYNOPSIS
            Indent line directly below line with opening curly bracket.

        .NOTES
            Because PlatyPS sometimes gets the indentation wrong with complex examples.

        .LINK
            https://regex101.com/r/eMCf3E/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose "Removing blank lines above closing curly bracket"

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $regex = [regex]::new('({\n)([^\s+].+)')

    $content = $content -replace $regex, "`$1    `$2"

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
