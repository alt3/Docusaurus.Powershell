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
    . "$((Get-Item -Path $PSCommandPath).Directory.Parent)/Bootstrap.ps1" -TestFolder (Get-Item -Path $PSCommandPath)
    Import-Module $test.Module -Force -DisableNameChecking -Verbose:$False -Scope Global
    InModuleScope Alt3.Docusaurus.PowerShell -Parameters @{testModule = $test.Module; tempFolder = $test.TempFolder } {
        New-DocusaurusHelp -Module $testModule -DocsFolder $tempFolder # generate Docusaurus files in $env:Temp
    }

    Write-Host "name = $($test.Name)"
    Write-Host "module = $($test.Module)"

    $generatedMdx = Get-Content -Path $test.MdxFile
    $expectedMdx = Get-Content (Join-Path -Path $test.Folder -ChildPath "Expected.mdx")
}

Describe "Integration Test to ensure all supported Code Example variants render identically on all PowerShell versions" {
    It "Mdx file generated for test should exist" {
        $test.MdxFile | Should -Exist
    }

    It "Mdx file generated for test should not contain CRLF" {
        (Get-Content -Path $test.MdxFile -Raw) -match "`r`n" | Should -Be $False
    }

    It "Content of generated mdx file is identical to that of expected fixture" {
        $generatedMdx | Should -BeExactly $expectedMdx
    }
}

AfterAll {
    if (Get-Module Alt3.Docusaurus.PowerShell) {
        # Remove-Item $test.TempFolder -Recurse -Force
    }
}
