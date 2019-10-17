function GetMdxFilePath() {
    <#
        .SYNOPSIS
            Returns the .mdx file path for a given .md file.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    Join-Path $MarkdownFile.DirectoryName -ChildPath "$([System.IO.Path]::GetFileNameWithoutExtension($MarkdownFile.Name)).mdx"
}
