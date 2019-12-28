<#
    .SYNOPSIS
        This test ensures that ALL Powershell versions render the code examples as expected.
#>

# -----------------------------------------------------------------------------
# import the Alt3.Docusaurus.Powershell rendering module
# -----------------------------------------------------------------------------
if (-not(Get-Module Alt3.Docusaurus.Powershell)) {
    Import-Module Alt3.Docusaurus.Powershell -DisableNameChecking -Verbose:$False -Scope Global
}

# -----------------------------------------------------------------------------
# import the test module associated with this test
# -----------------------------------------------------------------------------
${global:testModuleName} = [regex]::replace([System.IO.Path]::GetFileName($PSCommandPath), '.Tests.ps1', '')
${global:testModulePath} = Join-Path -Path $PSScriptRoot -ChildPath "${global:testModuleName}.psm1"
Import-Module ${global:testModulePath} -Force -DisableNameChecking -Verbose:$False -Scope Global

# -----------------------------------------------------------------------------
# the actual integration test
# -----------------------------------------------------------------------------
Describe "Integration Test to ensure all supported Code Example variants render identically on all Powershell versions" {

    # render the markdown
    ${global:outputFolder} = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ${global:testModuleName}
    InModuleScope Alt3.Docusaurus.Powershell {
        New-DocusaurusHelp -Module ${global:testModulePath} -OutputFolder ${global:outputFolder} -Verbose
    }

    # read markdown
    $renderedMdx = Get-Content (Join-Path -Path ${global:outputFolder} -ChildPath "commands" | Join-Path -ChildPath "Test-$(${global:testModuleName}).mdx")
    $expectedMdx = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "$(${global:testModuleName}).expected.mdx")

    # make sure output is identical
    It "generates markdown that is identical to the markdown found in our static 'expected' mdx file" {
        $renderedMdx | Should -BeExactly $expectedMdx
    }
}
