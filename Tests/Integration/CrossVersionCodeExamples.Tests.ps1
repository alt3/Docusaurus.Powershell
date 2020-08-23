#Requires -Modules Pester
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
    ${global:DocsFolder} = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ${global:testModuleName}
    InModuleScope Alt3.Docusaurus.Powershell {
        New-DocusaurusHelp -Module ${global:testModulePath} -DocsFolder ${global:DocsFolder}
    }

    # make sure folder docs/commands is generated
    $commandsFolder = Join-Path -Path ${global:DocsFolder} -ChildPath "commands"

    It "generates docs/commands folder $commandsFolder" {
        Test-Path -Path $commandsFolder | Should -Be $True
    }

    # make sure expected markdown file is rendered
    $renderedMdxFile = Join-Path -Path $commandsFolder -ChildPath "Test-$(${global:testModuleName}).mdx"

    It "generates mdx file $renderedMdxFile" {
        Test-Path -Path $renderedMdxFile | Should -Be $True
    }

    # compare generated mdx with expected mdx
    $renderedMdx = Get-Content $renderedMdxFile
    $expectedMdx = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "$(${global:testModuleName}).expected.mdx")

    It "generates markdown that is identical to the markdown found in the 'expected' mdx file" {
        $renderedMdx | Should -BeExactly $expectedMdx
    }

    # make sure the file does not contain CRLF
    It "generates a file without CRLF" {
        (Get-Content -Path $renderedMdxFile -Raw) -match "`r`n" | Should -Be $False
    }
}

# -----------------------------------------------------------------------------
# cleanup
# -----------------------------------------------------------------------------
Remove-Item ${global:DocsFolder} -Recurse -Force
