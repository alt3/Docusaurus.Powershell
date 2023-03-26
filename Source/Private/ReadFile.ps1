function ReadFile() {
    <#
        .SYNOPSIS
            Retrieves raw markdown from file.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [switch]$Raw
    )

    # file content as string
    if ($Raw) {
        return (Get-Content -Path $MarkdownFile.FullName -Raw).TrimEnd()
    }

    # file content as array of lines
    Get-Content -Path $MarkdownFile.FullName
}
