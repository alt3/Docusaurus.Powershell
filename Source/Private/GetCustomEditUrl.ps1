function GetCustomEditUrl() {
    <#
        .SYNOPSIS
            Returns the `custom_edit_url` for the given .md file.

        .DESCRIPTION
            Generates a URL pointing to the Powershell source file that was used to generate the markdown file.

        .NOTES
            - URLs for non-monolithic modules point to a .ps1 file with same name as the markdown file
            - URLs for monolithic modules will always point to a .psm1 with same name as passed module
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Module,
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $True)][string]$EditUrl,
        [switch]$Monolithic
    )

    # use command for non-monlithics
    if (-not($Monolithic)) {
        $command = [System.IO.Path]::GetFileNameWithoutExtension($MarkdownFile)

        return $EditUrl + '/' + $command + ".ps1"
    }

    # use module name for monolithics
    if (Test-Path $Module) {
        $Module = [System.IO.Path]::GetFileNameWithoutExtension($Module)
    }

    return $EditUrl + '/' + $Module + ".psm1"
}
