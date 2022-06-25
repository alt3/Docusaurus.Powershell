function GetCustomEditUrl() {
    <#
        .SYNOPSIS
            Returns the `custom_edit_url` for the given .md file.

        .DESCRIPTION
            Generates a URL pointing to the PowerShell source file that was used to generate the markdown file.

        .NOTES
            - passing string `null` will return string `null`
            - URLs for non-monolithic modules point to a .ps1 file with same name as the markdown file
            - URLs for monolithic modules will always point to a .psm1 with same name as passed module
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Module,
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $False)][string]$EditUrl,
        [switch]$Monolithic
    )

    # return $null so Docusaurus will not render the `Edit this page` button
    if (-not $EditUrl) {
        return
    }

    # if string "null" was passed explicitely, return as-is
    if ($EditUrl -eq "null") {
        return "null"
    }

    # removing trailing slashes
    $EditUrl = $EditUrl.TrimEnd("/")

    # point to the function source file for non-monlithic modules
    if (-not $Monolithic) {
        $command = [System.IO.Path]::GetFileNameWithoutExtension($MarkdownFile)

        return $EditUrl + '/' + $command + ".ps1"
    }

    # point to the module source file for monolithic modules
    if (Test-Path $Module) {
        $Module = [System.IO.Path]::GetFileNameWithoutExtension($Module)
    }

    return $EditUrl + '/' + $Module + ".psm1"
}
