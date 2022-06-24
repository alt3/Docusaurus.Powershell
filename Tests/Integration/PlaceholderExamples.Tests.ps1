#Requires -Modules Pester
<#
    .SYNOPSIS
        This test ensures:
        - PlatyPS generated placeholder examples render as expected on all platforms
        - the `-NoPlaceHolderExamples` leads to an empty `EXAMPLES` section
#>

BeforeDiscovery {
    if (-not(Get-Module Alt3.Docusaurus.PowerShell)) {
        throw "Required module 'Alt3.Docusaurus.Powershell' is not loaded."
    }
}

BeforeAll {
    # import the PlaceholderExamples.psm1 test module
    $testModuleName = [regex]::replace([System.IO.Path]::GetFileName($PSCommandPath), '.Tests.ps1', '')
    $testModulePath = Join-Path -Path $PSScriptRoot -ChildPath "$testModuleName.psm1"
    Import-Module $testModulePath -Force -DisableNameChecking -Verbose:$False -Scope Global

    # generate Docusaurus docs folder using default settings
    $docsFolderDefault = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "$testModuleName-Default"
    InModuleScope Alt3.Docusaurus.PowerShell -Parameters @{TestModulePath = $testModulePath; DocsFolder = $docsFolderDefault } {
        New-DocusaurusHelp -Module $testModulePath -DocsFolder $DocsFolder
    }

    $renderedMdxFileDefault = Join-Path -Path $docsFolderDefault -ChildPath "commands" | Join-Path -ChildPath "Test-$testModuleName.mdx"
    $renderedMdxDefault = Get-Content $renderedMdxFileDefault
    $expectedMdxDefault = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "$testModuleName.DEFAULT.expected.mdx")

    # generate Docusaurus docs folder using the -NoPlaceholderExamples switch parameter
    $docsFolderNoPlaceholders = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "$testModuleName-NoPlacehoders"
    InModuleScope Alt3.Docusaurus.PowerShell -Parameters @{TestModulePath = $testModulePath; DocsFolder = $docsFolderNoPlaceholders } {
        New-DocusaurusHelp -Module $testModulePath -DocsFolder $DocsFolder -NoPlaceholderExamples
    }

    $renderedMdxFileNoPlaceholders = Join-Path -Path $docsFolderNoPlaceholders -ChildPath "commands" | Join-Path -ChildPath "Test-$testModuleName.mdx"
    $renderedMdxNoPlaceholders = Get-Content $renderedMdxFileNoPlaceholders
    $expectedMdxNoPlaceholders = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "$testModuleName.NOPLACEHOLDERS.expected.mdx")

}

Describe "Integration Test for PlatyPS generated placeholder examples" {
    It "Mdx file generated for testing DEFAULT should exist" {
        $renderedMdxFileDefault | Should -Exist
    }

    It "Content of DEFAULT generated mdx file is identical to that of expected fixture (with PlatyPS example placeholders)" {
        $renderedMdxDefault | Should -BeExactly $expectedMdxDefault
    }

    It "Generated DEFAULT mdx file does not contain CRLF" {
        (Get-Content -Path $renderedMdxFileDefault -Raw) -match "`r`n" | Should -Be $False
    }

    It "Mdx file generated for testing NOPLACEHOLDERS should exist" {
        $renderedMdxFileNoPlaceholders | Should -Exist
    }

    It "Content of NOPLACEHOLDERS generated mdx file is identical to that of expected fixture (without PlatyPS example placeholders)" {
        $renderedMdxNoPlaceholders | Should -BeExactly $expectedMdxNoPlaceholders
    }

    It "Generated NOPLACEHOLDERS mdx file does not contain CRLF" {
        (Get-Content -Path $renderedMdxFileNoPlaceholders -Raw) -match "`r`n" | Should -Be $False
    }
}

AfterAll {
    if (Get-Module Alt3.Docusaurus.PowerShell) {
        Remove-Item $docsFolderDefault -Recurse -Force
        Remove-Item $docsFolderNoPlaceholders -Recurse -Force
    }
}
