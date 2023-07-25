function CreateOrCleanFolder() {
    <#
        .SYNOPSIS
            Helper function to create a folder OR remove it's contents if it already exists.
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Path,
        [switch]$GroupByVerb
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    # create the folder if it does not exist
    if (-not(Test-Path -Path $Path)) {
        Write-Verbose "=> creating folder $($Path)"
        New-Item -Path $Path -ItemType Directory -Force

        return
    }

    # otherwise remove it's contents
    Write-Verbose "=> cleaning folder $($Path)"
    if ($GroupByVerb) {
        # remove all files except the category files, start with verb subfolders
        Remove-Item -Path (Join-Path -Path $Path -ChildPath */*.*) -Exclude @('_category_.yaml', '_category_.json')
        # now remove all files in the root folder except the category files
        Remove-Item -Path (Join-Path -Path $Path -ChildPath *.*) -Exclude @('_category_.yaml', '_category_.json')
    } else {
        Remove-Item -Path (Join-Path -Path $Path -ChildPath *.*)
    }
}
