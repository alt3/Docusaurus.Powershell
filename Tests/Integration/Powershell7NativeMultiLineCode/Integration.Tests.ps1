<#
    .SYNOPSIS
        This test ensures PowerShell 7 native multi-line code examples render as expected.
#>

BeforeDiscovery {
    if (-not(Get-Module Alt3.Docusaurus.PowerShell)) {
        throw "Required module 'Alt3.Docusaurus.Powershell' is not loaded."
    }

    [bool]$isPS7 = $PSVersionTable.PSVersion.Major -eq 7 # -Skip tests if not on PowerShell 7
}

BeforeAll {
    . "D:\vscodeprojects\Powershell\Alt3.Docusaurus.PowerShell\Tests\Integration\Bootstrap.ps1" -TestFolder (Get-Item -Path $PSCommandPath)
    Import-Module $test.Module -Force -DisableNameChecking -Verbose:$False -Scope Global
    InModuleScope Alt3.Docusaurus.PowerShell -Parameters @{testModule = $test.Module; tempFolder = $test.TempFolder } {
        New-DocusaurusHelp -Module $testModule -DocsFolder $tempFolder # generate Docusaurus files in $env:Temp
    }

    $generatedMdx = Get-Content -Path $test.MdxFile
    $expectedMdx = Get-Content (Join-Path -Path $test.Folder -ChildPath "Expected.mdx")
}

Describe "Integration Test to ensure PowerShell 7 Native Multi-Line Code Examples render as expected" {
    It "Mdx file generated for test should exist" -Skip:(-not $isPS7) {
        $test.MdxFile | Should -Exist
    }

    It "Mdx file generated for test should not contain CRLF" -Skip:(-not $isPS7) {
        (Get-Content -Path $test.MdxFile -Raw) -match "`r`n" | Should -Be $False
    }

    It "Content of generated mdx file is identical to that of expected fixture" -Skip:(-not $isPS7) {
        $generatedMdx | Should -BeExactly $expectedMdx
    }
}

AfterAll {
    if (Get-Module Alt3.Docusaurus.PowerShell) {
        Remove-Item $test.TempFolder -Recurse -Force
    }
}
