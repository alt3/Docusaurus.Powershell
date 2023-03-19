function WriteFile() {
    <#
        .SYNOPSIS
            Writes content to a UTF-8 file without BOM using LF as newlines.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $True)]$Content
    )

    # replace file (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False

    # when content is a string
    if (($Content.GetType().Name -eq "String")) {
        [System.IO.File]::WriteAllText($MarkdownFile.FullName, $Content, $fileEncoding)

        return
    }

    # when content is an array
    [System.IO.File]::WriteAllLines($MarkdownFile.FullName, $Content, $fileEncoding)
}
