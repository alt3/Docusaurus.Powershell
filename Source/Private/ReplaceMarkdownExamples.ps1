function ReplaceMarkdownExamples() {
    <#
        .SYNOPSIS
            Replace PlatyPS generated code block examples.

        .DESCRIPTION
            Replaces custom fenced code blocks and placeholder examples, otherwise uses PlatyPS generated defaults.

            See link below for a detailed description of the determination process.

        .LINK
            https://github.com/alt3/Docusaurus.Powershell/issues/14#issuecomment-568552556
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [switch]$NoPlaceHolderExamples
    )

    $content = ReadFile -MarkdownFile $MarkdownFile
    [string]$newExamples = ""

    # ---------------------------------------------------------------------
    # extract all EXAMPLE nodes
    # https://regex101.com/r/y4UxP8/2
    # ---------------------------------------------------------------------
    $regexExtractExamples = [regex]::new('### (EXAMPLE|Example) [0-9][\s\S]*?(?=\n.*?#|$)')
    $examples = $regexExtractExamples.Matches($content)

    if ($examples.Count -eq 0) {
        Write-Warning "Unable to find any EXAMPLE nodes. Please check your Get-Help definitions before filing an issue!"
    }

    # process each EXAMPLE node
    $examples | ForEach-Object {
        $example = $_

        # ---------------------------------------------------------------------
        # do not modify if it's a PlatyPS placeholder example
        # https://regex101.com/r/WOQL0l/4
        # ---------------------------------------------------------------------
        $regexPlatyPlaceholderExample = [regex]::new('{{ Add example code here }}')
        if ($example -match $regexPlatyPlaceholderExample) {

            if ($NoPlaceHolderExamples) {
                Write-Verbose "=> Example 1: PlatyPS Placeholder (dropping)"
                return
            }

            Write-Verbose "=> Example 1: PlatyPS Placeholder (keeping)"
            $newExamples += "$example`n"
            return
        }

        # ---------------------------------------------------------------------
        # Powershell 6: re-construct Code Fenced example
        # - https://regex101.com/r/lHdZHM/6 => without a description
        # - https://regex101.com/r/CGjQco/3 => with a description
        # ---------------------------------------------------------------------
        $regexPowershell6TripleCodeFence = [regex]::new('(### EXAMPLE ([0-9|[0-9]+))\n(```\n(```|```ps|```posh|```powershell)\n```\n)\n([\s\S]*?)\\`\\`\\`(\n\n|\n)([\s\S]*|\n)')

        if ($example -match $regexPowershell6TripleCodeFence) {
            $header = $matches[1]
            $code = $matches[5]
            $description = $matches[7]

            Write-Verbose "=> $($header): Triple Code Fence (Powershell 6 and lower)"

            $newExample = NewMarkdownExample -Header $header -Code $code -Description $description
            $newExamples += $newExample
            return
        }

        # ---------------------------------------------------------------------
        # Powershell 7: re-construct PlatyPS Paired Code Fences example
        # - https://regex101.com/r/FRA139/1 => without a description
        # - https://regex101.com/r/YIIwUs/5 => with a description
        # ---------------------------------------------------------------------
        $regexPowershell7PairedCodeFences = [regex]::new('(### EXAMPLE ([0-9]|[0-9]+))\n(```\n(```|```ps|```posh|```powershell)\n)([\s\S]*?)```\n```(\n\n|\n)([\s\S]*|\n)')

        if ($example -match $regexPowershell7PairedCodeFences) {
            $header = $matches[1]
            $code = $matches[5]
            $description = $matches[7]

            Write-Verbose "=> $($header): Paired Code Fences (Powershell 7)"

            $newExample = NewMarkdownExample -Header $header -Code $code -Description $description
            $newExamples += $newExample
            return
        }

        # ---------------------------------------------------------------------
        # Powershell 7:  re-construct non-adjacent Code Fenced example
        # - https://regex101.com/r/kLr98l/3 => without a description
        # - https://regex101.com/r/eJH4cQ/6 => with a complex description
        # ---------------------------------------------------------------------
        $regexPowershell7NonAdjacentCodeBlock = [regex]::new('(### EXAMPLE ([0-9]|[0-9]+))\n(```\n(```|```ps|```posh|```powershell)\n)([\s\S]*?)\\`\\`\\`(\n\n([\s\S]*)|\n)')

        if ($example -match $regexPowershell7NonAdjacentCodeBlock) {
            $header = $matches[1]
            $code = $matches[5] -replace ('```' + "`n"), ''
            $description = $matches[7]

            Write-Verbose "=> $($header): Non-Adjacent Code Block (Powershell 7)"

            $newExample = NewMarkdownExample -Header $header -Code $code -Description $description
            $newExamples += $newExample
            return
        }

        # ---------------------------------------------------------------------
        # no matches so we simply use the unaltered PlatyPS generated example
        # - https://regex101.com/r/rllmTj/1 => without a decription
        # - https://regex101.com/r/kTH75U/1 => with a description
        # ---------------------------------------------------------------------
        $regexPlatyPsDefaults = [regex]::new('(### EXAMPLE ([0-9]|[0-9]+))\n```\n([\s\S]*)```\n([\s\S]*)')

        if ($example -match $regexPlatyPsDefaults) {
            $header = $matches[1]
            $code = $matches[5] -replace ('```' + "`n"), ''
            $description = $matches[7]

            Write-Verbose "=> $($header): PlatyPS Default (all Powershell versions)"

            $newExamples += "$example`n"
            return
        }

        # we should never reach this point
        Write-Warning "Unsupported code block detected, please file an issue containing the error message below at https://github.com/alt3/Docusaurus.Powershell/issues"
        Write-Warning $example
    }

    # replace EXAMPLES section in content with updated examples
    # https://regex101.com/r/8OEW0w/1/
    $regex = '## EXAMPLES\n[\s\S]+## PARAMETERS'
    $replacement = "## EXAMPLES`n`n$($newExamples)## PARAMETERS"
    $content = [regex]::replace($content, $regex, $replacement)

    # replace file
    WriteFileContent -MarkdownFile $MarkdownFile -Content $content
}
