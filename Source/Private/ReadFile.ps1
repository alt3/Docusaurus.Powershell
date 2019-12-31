function ReadFile() {
    <#
        .SYNOPSIS
            Retrieves raw markdown from file.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    (Get-Content -Path $MarkdownFile.FullName -Raw).TrimEnd()
}
