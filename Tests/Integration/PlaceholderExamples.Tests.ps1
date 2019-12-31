<#
    .SYNOPSIS
        This test ensures:
        - PlatyPS generated placeholder examples render as expected on all platforms
        - the `-NoPlaceHolderExamples` leads to an empty `EXAMPLES` section
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
Describe "Integration Test for PlatyPS generated placeholder examples" {
    Context "when using default settings" {

        # render the markdown
        ${global:DocsFolder} = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ${global:testModuleName}
        InModuleScope Alt3.Docusaurus.Powershell {
            New-DocusaurusHelp -Module ${global:testModulePath} -DocsFolder ${global:DocsFolder}
        }

        # read markdown
        $renderedMdx = Get-Content (Join-Path -Path ${global:DocsFolder} -ChildPath "commands" | Join-Path -ChildPath "Test-$(${global:testModuleName}).mdx")
        $expectedMdx = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "$(${global:testModuleName}).ENABLED.expected.mdx")

        # make sure output is identical
        It "renders placeholder markdown that is identical to the markdown found in our static 'ENABLED.expected' mdx file" {
            $renderedMdx | Should -BeExactly $expectedMdx
        }
    }

    Context "when using the -NoPlaceholderExamples switch parameter" {

        # render the markdown
        ${global:DocsFolder} = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ${global:testModuleName}
        InModuleScope Alt3.Docusaurus.Powershell {
            New-DocusaurusHelp -Module ${global:testModulePath} -DocsFolder ${global:DocsFolder} -NoPlaceHolderExamples
        }

        # read markdown
        $renderedMdxFile = Join-Path -Path ${global:DocsFolder} -ChildPath "commands" | Join-Path -ChildPath "Test-$(${global:testModuleName}).mdx"
        $renderedMdx = Get-Content $renderedMdxFile
        $expectedMdx = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "$(${global:testModuleName}).DISABLED.expected.mdx")

        # make sure output is identical
        It "renders empty EXAMPLES section markdown that is identical to the markdown found in our static 'DISABLED.expected' mdx file" {
            $renderedMdx | Should -BeExactly $expectedMdx
        }

        It "generates a file without CRLF" {
            (Get-Content -Path $renderedMdxFile -Raw) -match "`r`n" | Should -Be $False
        }
    }
}

# -----------------------------------------------------------------------------
# cleanup
# -----------------------------------------------------------------------------
Remove-Item ${global:DocsFolder} -Recurse -Force
