function ReplaceExamples() {
    <#
        .SYNOPSIS
            Replaces PlatyPS generated example sections with Docusaurus compatible markdown examples.

        .DESCRIPTION
            PlatyPS preserves the authored example help almost verbatim which means we need to:

            - wrap "native" examples (not using a code fence) in a powershell fenced code block
            - normalize the language moniker of fenced examples (```, ```ps and ```posh all become ```powershell)
            - replace the PlatyPS placeholder example (generated for commands without Get-Help
              definitions) with a Docusaurus friendly variant
            - insert a placeholder example when the command has no examples at all

            The `-NoPlaceholderExamples` switch drops placeholder examples instead, resulting
            in an empty `EXAMPLES` section.
    #>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "NoPlaceHolderExamples",
        Justification = 'False positive as rule does not scan child scopes')]
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [switch]$NoPlaceHolderExamples
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw
    $newExamples = [System.Collections.Generic.List[string]]::new()

    # ---------------------------------------------------------------------
    # extract all EXAMPLE nodes
    # ---------------------------------------------------------------------
    $regexExtractExamples = [regex]'### (EXAMPLE|Example) [0-9]+[\s\S]*?(?=\n### (EXAMPLE|Example) [0-9]+|\n## PARAMETERS|$)'
    $examples = $regexExtractExamples.Matches($content)

    # process each EXAMPLE node
    $examples | ForEach-Object {
        $example = $_.Value.Trim([char]10)

        # split the markdown header from the example body
        $header, $body = $example -split "`n", 2
        $header = $header.Trim()
        $body = "$body".Trim([char]10)

        # ---------------------------------------------------------------------
        # PlatyPS placeholder example, generated for commands without a Get-Help
        # definition => replace with Docusaurus friendly variant (or drop)
        # ---------------------------------------------------------------------
        if ($body -match '{{ Add example description here }}' -and $body -notmatch '```') {
            if ($NoPlaceHolderExamples) {
                Write-Verbose "=> $($header): PlatyPS Placeholder (dropping)"
                return
            }

            Write-Verbose "=> $($header): PlatyPS Placeholder (keeping)"
            $newExamples.Add((NewMarkdownExample -Header "### Example 1" -Code 'PS C:\> {{ Add example code here }}' -Description '{{ Add example description here }}'))
            return
        }

        # ---------------------------------------------------------------------
        # code fenced example => normalize the moniker of the leading code fence
        # (all other code fences are left untouched)
        # ---------------------------------------------------------------------
        $regexLeadingFence = [regex]'^```(ps|posh|powershell)?[ \t]*\n'

        if ($body -match $regexLeadingFence) {
            Write-Verbose "=> $($header): Code Fenced example"

            $body = $regexLeadingFence.Replace($body, '```powershell' + "`n", 1)
            $newExamples.Add("$header`n`n$body")
            return
        }

        # ---------------------------------------------------------------------
        # native example (no code fence) => Get-Help treats the first paragraph
        # as code so we wrap it in a powershell fenced code block
        # ---------------------------------------------------------------------
        Write-Verbose "=> $($header): Native example"

        $code, $description = $body -split "`n`r?`n", 2
        $newExamples.Add((NewMarkdownExample -Header $header -Code $code -Description "$description"))
    }

    # ---------------------------------------------------------------------
    # no examples at all => insert a placeholder example (or leave empty)
    # ---------------------------------------------------------------------
    if ($examples.Count -eq 0 -and -not $NoPlaceHolderExamples) {
        Write-Verbose "=> No examples found: inserting placeholder example"
        $newExamples.Add((NewMarkdownExample -Header "### Example 1" -Code 'PS C:\> {{ Add example code here }}' -Description '{{ Add example description here }}'))
    }

    # replace EXAMPLES section in content with updated examples
    $regex = '## EXAMPLES\n[\s\S]+?## PARAMETERS'
    $joinedExamples = ($newExamples -join "`n`n").Replace('$', '$$') # Escape regex replacement $-substitutions (https://github.com/alt3/Docusaurus.Powershell/pull/98)

    if ($newExamples.Count -eq 0) {
        $replacement = "## EXAMPLES`n`n## PARAMETERS"
    } else {
        $replacement = "## EXAMPLES`n`n$($joinedExamples)`n`n## PARAMETERS"
    }

    $content = [regex]::replace($content, $regex, $replacement)

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
