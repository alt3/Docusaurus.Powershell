function GetCustomEditUrl() {
    <#
        .SYNOPSIS
            Returns the `custom_edit_url` for the given .md file.

        .DESCRIPTION
            Generates a URL pointing to the Powershell source file that was used to generate the markdown file.
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Module,
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $True)][string]$EditUrl,
        [switch]$Monolithic
    )

    # monolithic
    if ($Monolithic) {
        if (Test-Path -Path $Module) {
            $sourceFile = [System.IO.Path]::GetFileNameWithoutExtension($Module) + '.psm1'
        } else {
            $modulePath = (Get-Module $Module).path
            $sourceFile = [System.IO.Path]::GetFileName($modulePath)
        }

        return $EditUrl + '/' + $sourceFile
    }

    # non-monolithic
    $command = [System.IO.Path]::GetFileNameWithoutExtension($MarkdownFile)

    return $EditUrl + '/' + $command + ".ps1"
}
