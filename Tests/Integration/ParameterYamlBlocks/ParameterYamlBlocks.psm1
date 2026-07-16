[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Scope = "Function")]
param()

function Test-ParameterYamlBlocks {
    <#
        .SYNOPSIS
            Dummy module to ensure PlatyPS generated parameter yaml blocks and named parameter set headings render as expected.

        .DESCRIPTION
            Ensures that:

            - the yaml code blocks are not touched by the markdown transformations
            - the SYNTAX section keeps a heading for each named parameter set
            - parameter descriptions are transformed like any other markdown (encoding
              raw <brackets> and {curly} brackets but not `<inline code>`)

        .PARAMETER Name
            Parameter description with `<inline code>`, raw <brackets> and {curly} brackets.

        .PARAMETER Limit
            An integer parameter with a default value.

        .PARAMETER Force
            A switch parameter available in all parameter sets.
    #>
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'ByName', HelpMessage = 'Enter a name')]
        [ValidateSet('One', 'Two')]
        [string]$Name,

        [Parameter(ParameterSetName = 'ByLimit')]
        [int]$Limit = 10,

        [switch]$Force
    )

    Write-Output "$Name $Limit $Force"
}
