#Requires -Modules Pester
<#
    .SYNOPSIS
        This test ensures PowerShell 7 native multi-line code examples render as expected.
#>

BeforeAll {
    [bool]$isPS7 = $PSVersionTable.PSVersion.Major -ge 7

    write-Host "isPS7 = $isPS7"

    if (-not(Get-Module Alt3.Docusaurus.PowerShell)) {
        throw "Required module 'Alt3.Docusaurus.Powershell' is not loaded."
    }

    # import the PS7NativeMultiLineCode.psm1 test module
    $testModuleName = [regex]::replace([System.IO.Path]::GetFileName($PSCommandPath), '.Tests.ps1', '')
    $testModulePath = Join-Path -Path $PSScriptRoot -ChildPath "$testModuleName.psm1"
    Import-Module $testModulePath -Force -DisableNameChecking -Verbose:$False -Scope Global

    # generate Docusaurus docs folder for the module
    $docsFolder = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath $testModuleName
    InModuleScope Alt3.Docusaurus.PowerShell -Parameters @{TestModulePath = $testModulePath; DocsFolder = $docsFolder }{
        New-DocusaurusHelp -Module $testModulePath -DocsFolder $DocsFolder
    }

    # handle generated .mdx file
    $renderedMdxFile = Join-Path -Path $docsFolder -ChildPath "commands" | Join-Path -ChildPath "Test-$testModuleName.mdx"
    $renderedMdx = Get-Content $renderedMdxFile
    $expectedMdx = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "$testModuleName.expected.mdx")
}

Describe "Integration Test to ensure PowerShell 7's Native Multi-Line Code Examples render as expected" {
    It "Mdx file generated for test should exist" -Skip:(-not $isPS7) {
        $renderedMdxFile | Should -Exist
    }
    # make sure output is identical
    It "Content of generated .mdx is identical to that of expected fixture" -Skip:(-not $isPS7) {
        $renderedMdx | Should -BeExactly $expectedMdx
    }

    It "Generated .mdx file does not contain CRLF" -Skip:(-not $isPS7) {
        (Get-Content -Path $renderedMdxFile -Raw) -match "`r`n" | Should -Be $False
    }
}

AfterAll {
    if (Get-Module Alt3.Docusaurus.PowerShell) {
        Remove-Item $docsFolder -Recurse -Force
    }
}
