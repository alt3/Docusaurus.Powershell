function IndentLineWithOpeningBracket() {
    <#
        .SYNOPSIS
            Corrects indentation for lines with opening curly brackets and incorrect indentation
            by comparing indentation of the line below (and recalculating if things are amiss).

        .NOTES
            Skips correcting if the line below has 4-space indentation

        .NOTES
            The regex gives us three useful matching groups:
            - Group 1 is the full first without the line feed
            - Group 2 is the full second line without the line feed
            - Group 3 contains the leading spaces of the second line

        .LINK
            https://regex101.com/r/mT2jLC/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose "Removing blank lines above closing curly bracket"

    $content = ReadFile -MarkdownFile $MarkdownFile

    $regex = [regex]::new('(?m)^([^\s].+{)\n((\s+)(.+))')

    $callback = {
        param($match)

        # do nothing if next line starts with 4 spaces
        if ($match.Groups[3].Value.Length -eq 4) {
            return $match
        }

        # divide spacing of next line by 2 and use that as correct indentation
        [string]$fixedIndentation = ""
        $fixedIndentation.PadRight(($match.Groups[3].Value.Length / 2 - 1), " ")

        $fixedIndentation + $match.Groups[1] + "`n" + $match.Groups[2]
    }

    $content = $regex.replace($content, $callback)

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
