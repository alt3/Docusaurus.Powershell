function ReplaceMarkdownCodeBlocks() {
    <#
        .SYNOPSIS
            Replace PlatyPS generated code blocks.

        .DESCRIPTION
            Replaces custom fenced code blocks and placeholder examples, otherwise uses PlatyPS generated defaults.

            See link below for a detailed description of the determination process.

        .LINK
            https://github.com/alt3/Docusaurus.Powershell/issues/14#issuecomment-568552556
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = (Get-Content -Path $MarkdownFile.FullName -Raw).TrimEnd()
    [string]$newExamples = ""

    # ---------------------------------------------------------------------
    # extract all EXAMPLE nodes
    # https://regex101.com/r/y4UxP8/2
    # ---------------------------------------------------------------------
    $regexExtractExamples = [regex]::new('### (EXAMPLE|Example) [0-9][\s\S]*?(?=\n.*?#|$)')
    $examples = $regexExtractExamples.Matches($content)

    # process each EXAMPLE node
    $examples | ForEach-Object {
        $example = $_

        # ---------------------------------------------------------------------
        # do not modify if it's a PlatyPS placeholder example
        # https://regex101.com/r/WOQL0l/4
        # ---------------------------------------------------------------------
        $regexPlatyPlaceholderExample = [regex]::new('{{ Add example code here }}')
        if ($regexPlatyPlaceholderExample.Matches($example)) {
            $newExamples += $example
            return
        }

        # ---------------------------------------------------------------------
        # Powershell 6: re-construct custom code-fenced example
        # https://regex101.com/r/lHdZHM/2/ => code block with description
        # https://regex101.com/r/0a44Tn/2/ => code block without description
        # ---------------------------------------------------------------------
        $regexCodeFencePowershell6 = [regex]::new('(### EXAMPLE [0-9])\n(```\n(```|```ps|```posh|```powershell)\n```\n)\n([\s\S]*?\\`\\`\\`)\n([\s\S]*|\n)')

        if ($example -match $regexCodeFencePowershell6) {
            $header = $matches[1]
            $code = $matches[4]
            $description  = $matches[5]

            $example = "$header`n" + '```' +  "`n$code`n$description`n"
            $newExamples += $example
            return
        }

        # ---------------------------------------------------------------------
        # Powershell 7: re-construct custom code-fenced example
        # https://regex101.com/r/oXsGLw/1/ => code block with description
        # https://regex101.com/r/Yd1lXR/1/ => code block without description
        # ---------------------------------------------------------------------
        $regexCodeFencePowershell7 = [regex]::new('(### EXAMPLE [0-9])\n(```\n(```|```ps|```posh|```powershell)\n)([\s\S]*?\\`\\`\\`)\n([\s\S]*|\n)')

        if ($example -match $regexCodeFencePowershell7) {
            $header = $matches[1]
            $codeblock1 = $matches[4]
            $codeblock2 = $matches[5]
            $description  = $matches[6]

            $example = "$header`n" + '```' + "`n$($codeblock1)$($codeblock2)`n$description`n"
            $newExamples += $example
            return
        }

        # ---------------------------------------------------------------------
        # no matches so we follow the Comment Based Help standard and thus use
        # PlatyPS generated code block. This regex will detect both single-
        # line and multi-line code examples and has support for Powershell v7.
        # ---------------------------------------------------------------------
        $regexDefaultCodeBlocks = [regex]::new('(### EXAMPLE [0-9])\n```\n([\s\S]*)```\n(([\s\S]*|\n|))?(?=\n.*?#|$)')

        if ($example -match $regexDefaultCodeBlocks) {
            $newExamples += "$example`n"
            return
        }

        # we should never reach this point
        write-warning "Unsupported code block detected, please file an issue at https://github.com/alt3/Docusaurus.Powershell/issues"
    }

    # replace EXAMPLES section in content with updated examples
    # https://regex101.com/r/8OEW0w/1/
    $regex = '## EXAMPLES\n[\s\S]+## PARAMETERS'
    $replacement = "## EXAMPLES`n`n$($newExamples)## PARAMETERS"
    $content = [regex]::replace($content, $regex, $replacement)

    # replace file (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($markdownFile.FullName, $content, $fileEncoding)
}
