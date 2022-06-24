# -----------------------------------------------------------------------------
# ModuleBuilder configuration file. Use this file to override the default
# parameter values used by the `Build-Module` command when building the module.
#
# For a full list of supported arguments run `Get-Help Build-Module -Full`.
# -----------------------------------------------------------------------------

@{
    Path = "Alt3.Docusaurus.PowerShell.psd1"
    VersionedOutputDirectory = $true
    CopyDirectories = @(
        'en-US'
    )
    Prefix = "Set-StrictMode -Version Latest`n`$PSDefaultParameterValues['*:ErrorAction'] = 'Stop' # full stop on first error"
}
