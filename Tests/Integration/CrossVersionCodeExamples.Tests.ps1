#Requires -Modules Pester
<#
    .SYNOPSIS
        This test ensures that ALL PowerShell versions render the code examples as expected.
#>

BeforeDiscovery {
    if (-not(Get-Module Alt3.Docusaurus.PowerShell)) {
        throw "Required module 'Alt3.Docusaurus.Powershell' is not loaded."
    }
}

BeforeAll {
    # import the CrossVersionCodeExamples.psm1 test module
    $testModuleName = [regex]::replace([System.IO.Path]::GetFileName($PSCommandPath), '.Tests.ps1', '')
    $testModulePath = Join-Path -Path $PSScriptRoot -ChildPath "$testModuleName.psm1"
    Import-Module $testModulePath -Force -DisableNameChecking -Verbose:$False -Scope Global

    # generate Docusaurus docs folder using default settings
    $docsFolder = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath $testModuleName
    InModuleScope Alt3.Docusaurus.PowerShell -Parameters @{TestModulePath = $testModulePath; DocsFolder = $docsFolder } {
        New-DocusaurusHelp -Module $testModulePath -DocsFolder $DocsFolder
    }

    # handle generated .mdx file
    $renderedMdxFile = Join-Path -Path $docsFolder -ChildPath "commands" | Join-Path -ChildPath "Test-$testModuleName.mdx"
    $renderedMdx = Get-Content $renderedMdxFile
    $expectedMdx = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "$testModuleName.expected.mdx")
}

Describe "Integration Test to ensure all supported Code Example variants render identically on all PowerShell versions" {
    It "Commands folder as required for Docusaurus docs/commands should be created" {
        Test-Path (Join-Path -Path $docsFolder -ChildPath commands) | Should -Be $True
    }

    It "Mdx file generated for test should exist" {
        $renderedMdxFile | Should -Exist
    }

    It "Content of generated mdx file is identical to that of expected fixture" {
        $renderedMdx | Should -BeExactly $expectedMdx
    }

    It "Generated mdx file does not contain CRLF" {
        (Get-Content -Path $renderedMdxFile -Raw) -match "`r`n" | Should -Be $False
    }
}

AfterAll {
    if (Get-Module Alt3.Docusaurus.PowerShell) {
        Remove-Item $docsFolder -Recurse -Force
    }
}
