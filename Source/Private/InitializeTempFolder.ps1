function InitializeTempFolder() {
    <#
        .SYNOPSIS
            Creates the temp folder and the `debug.info` file.

        .DESCRIPTION
            The temp folder is where all work is done before the enriched mdx files are copied
            to the docusaurus sidebar folder. We use this approach to support future debugging
            as it will be near impossible to reason about bugs without looking at the initial
            PlatyPS files, knowing which Powershell version was used etc.

            We might even instruct users to send us the files when reporting issues (which
            would require re-generating using the `-KeepTempFiles` switch).
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Path
    )

    Write-Verbose "Initializing temp folder:"
    CreateOrCleanFolder -Path $Path

    # prepare the debug info
    Write-Verbose "=> creating debug file"
    $debugInfo = [ordered]@{
        ModuleVersions = [ordered]@{
            "Alt3.Docusarus.Powershell" = (Get-Module "Alt3.Docusaurus.Powershell").Version
            PlatyPs = (Get-Module PlatyPs).Version
            Pester = (Get-Module Pester).Version
        }
        PSVersionTable = $PSVersionTable
    } | ConvertTo-Json

    # create the debug file
    $debugFile = Join-Path -Path $Path -ChildPath "debug.json"
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($debugFile, $debugInfo, $fileEncoding)
}
