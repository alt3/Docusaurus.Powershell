function InsertUserMarkdown() {
    <#
        .SYNOPSIS
            Inserts user provided markdown directly above OR below the PlatyPS generated markdown.

        .NOTES
            Will use file content as markdown if $Markdown resolves to a file.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $False)][string]$Markdown,
        [Parameter(Mandatory = $True)][ValidateSet('Prepend', 'Append')][string]$Mode
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    $content = ReadFile -MarkdownFile $MarkdownFile

    # use file content as markdown
    if (Test-Path $Markdown -ErrorAction SilentlyContinue) {
        $Markdown = Get-Content -Path $Markdown -Raw
    }

    # remove any leading or trailing newlines
    $Markdown = $Markdown.TrimStart()
    $Markdown = $Markdown.TrimEnd()

    # convert CRLF to LF
    $Markdown = $Markdown -replace "`r`n", "`n"

    # insert user markdown
    if ($Mode -eq "Prepend") {
        Write-Verbose "=> prepending user markdown"

        $regex = '(---\n\n)'
        $content = $content -replace $regex, "---`n`n$Markdown`n`n"
    }
    else {
        Write-Verbose "=> appending user markdown"

        $content = "$content`n`n$Markdown`n`n"
    }

    # create new file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
