function NewMarkdownExample() {
    <#
        .SYNOPSIS
            Generates a new markdown example block.
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Header,
        [Parameter(Mandatory = $True)][string]$Code,
        [Parameter(Mandatory = $False)][string]$Description = $null
    )

    $example = "$Header`n`n"
    $example += '```powershell' + "`n"
    $example += "$($Code.Trim([char]10))`n"
    $example += '```'

    if (-not [string]::IsNullOrWhiteSpace($Description)) {
        $example += "`n`n$($Description.Trim([char]10))"
    }

    return $example
}
