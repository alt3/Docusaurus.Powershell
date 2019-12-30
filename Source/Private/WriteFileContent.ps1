function WriteFileContent() {
    <#
        .SYNOPSIS
            Writes content to a UTF-8 file without BOM using LF as newlines.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $True)][string]$Content
    )

    # replace file (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllText($MarkdownFile.FullName, $Content, $fileEncoding)
}
