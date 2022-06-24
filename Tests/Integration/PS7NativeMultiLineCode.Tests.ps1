#Requires -Modules Pester
<#
    .SYNOPSIS
        This test ensures PowerShell 7 native multi-line code examples render as expected.
#>

# -----------------------------------------------------------------------------
# skip test on PowerShell 6 and lower
# -----------------------------------------------------------------------------
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "[+] skipping test because PowerShell 6 or lower" -ForegroundColor magenta
    return
}

# -----------------------------------------------------------------------------
# import the Alt3.Docusaurus.PowerShell rendering module
# -----------------------------------------------------------------------------
if (-not(Get-Module Alt3.Docusaurus.PowerShell)) {
    Import-Module Alt3.Docusaurus.PowerShell -DisableNameChecking -Verbose:$False -Scope Global
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
Describe "Integration Test to ensure PowerShell 7's Native Multi-Line Code Examples render as expected" {

    # render the markdown
    ${global:DocsFolder} = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ${global:testModuleName}
    InModuleScope Alt3.Docusaurus.PowerShell {
        New-DocusaurusHelp -Module ${global:testModulePath} -DocsFolder ${global:DocsFolder}
    }

    # read markdown
    $renderedMdxFile = Join-Path -Path ${global:DocsFolder} -ChildPath "commands" | Join-Path -ChildPath "Test-$(${global:testModuleName}).mdx"
    $renderedMdx = Get-Content $renderedMdxFile
    $expectedMdx = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "$(${global:testModuleName}).expected.mdx")

    # make sure output is identical
    It "generates markdown that is identical to the markdown found in our static 'expected' mdx file" {
        $renderedMdx | Should -BeExactly $expectedMdx
    }

    It "generates a file without CRLF" {
        (Get-Content -Path $renderedMdxFile -Raw) -match "`r`n" | Should -Be $False
    }
}

# -----------------------------------------------------------------------------
# cleanup
# -----------------------------------------------------------------------------
Remove-Item ${global:DocsFolder} -Recurse -Force
