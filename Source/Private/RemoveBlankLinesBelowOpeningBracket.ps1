function RemoveBlankLinesBelowOpeningBracket() {
    <#
        .SYNOPSIS
            Removes blank lines below lines ending with an opening curly bracket.

        .NOTES
            Required so following steps can trust formatting.

        .LINK
            https://regex101.com/r/FAdpGh/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose "Removing blank lines below opening curly bracket"

    $content = ReadFile -MarkdownFile $MarkdownFile

    $regex = [regex]::new('({\n+\n)')

    $content = $content -replace $regex, "{`n"

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
