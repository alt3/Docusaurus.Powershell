function EscapeOpeningCurlyBrackets() {
    <#
        .SYNOPSIS
            Escape opening curly brackets so `{` becomes `\{` (except inside code blocks
            and inline code).

        .NOTES
            Required because MDX treats curly brackets as JSX expressions which would
            break the Docusaurus build. Code blocks and inline code need no escaping
            (and would render the backslashes literally).
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    $i = 0
    [bool]$codeblock = $False

    foreach($line in $content) {
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

                $segments[$s] = [regex]::replace($segments[$s], '{', '\{')
            }

            $content[$i] = $segments -join ''
        }

        $i++
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
