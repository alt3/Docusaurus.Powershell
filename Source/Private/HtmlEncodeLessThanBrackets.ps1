function HtmlEncodeLessThanBrackets() {
    <#
        .SYNOPSIS
            Html encode `<` brackets, both raw and backslash-escaped (except inside code
            blocks and inline code).

        .NOTES
            Required because MDX treats raw `<` brackets as JSX component tags which
            would break the Docusaurus build.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    $i = 0
    [bool]$codeblock = $False
    [bool]$frontmatter = $content[0] -eq '---'

    foreach($line in $content) {
        # skip the front matter, it is yaml data without MDX escaping requirements
        if ($frontmatter) {
            if ($i -gt 0 -and $line -eq '---') {
                $frontmatter = $False
            }

            $i++
            continue
        }

        if ($line -match '```' -and $codeblock -eq $False) {
            $codeblock = $True
        } elseif ($line -match '```' -and $codeblock -eq $True) {
            $codeBlock = $False
        }

        if ($codeblock -eq $False) {
            # transform the line except for inline code segments
            $segments = [regex]::Split($line, '(`[^`]*`)')

            for ($s = 0; $s -lt $segments.Count; $s++) {
                if ($segments[$s].StartsWith('`')) {
                    continue
                }

                $segments[$s] = [regex]::replace($segments[$s], '(\\\\\\\<|\\\<)', '&lt;') # backslash-escaped brackets
                $segments[$s] = [regex]::replace($segments[$s], '\<', '&lt;') # raw brackets
            }

            $content[$i] = $segments -join ''
        }

        $i++
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
