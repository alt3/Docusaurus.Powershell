function RemoveFile() {
    <#
        .SYNOPSIS
            Helper function to remove a file if it exists.
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Path
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose "=> removing $Path"

    if (Test-Path -Path $Path) {
        Remove-Item -Path $Path -Force
    }
}
