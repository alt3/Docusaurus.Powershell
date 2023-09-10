BeforeDiscovery {
    if (-not(Get-Module Alt3.Docusaurus.Powershell)) {
        throw "Required module 'Alt3.Docusaurus.Powershell' is not loaded."
    }

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    [bool]$isPS7 = $PSVersionTable.PSVersion.Major -eq 7 # -Skip tests if not on PowerShell 7
}

BeforeAll {
    . "$((Get-Item -Path $PSCommandPath).Directory.Parent.FullName)/Bootstrap.ps1" -TestFolder (Get-Item -Path $PSCommandPath)
    Import-Module $test.Module -Force -DisableNameChecking -Verbose:$False -Scope Global

    # generate and read Docusaurus files in $env:Temp
    InModuleScope Alt3.Docusaurus.Powershell -Parameters @{testModule = $test.Module; tempFolder = $test.TempFolder } {
        New-DocusaurusHelp -Module $testModule -DocsFolder $tempFolder
    }

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    $generatedMdx = Get-Content -Path $test.MdxFile

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    $expectedMdx = Get-Content (Join-Path -Path $test.Folder -ChildPath "Expected.mdx")
}

Describe "Integration test to ensure PowerShell 7 Native Multi-Line Code Examples render as expected" -Skip:(-not $isPS7) {
    It "Mdx file generated for test should exist" {
        $test.MdxFile | Should -Exist
    }

    It "Mdx file generated for test should have content" {
        $generatedMdx | Should -Not -BeNullOrEmpty
    }

    It "Mdx file generated for test should not contain CRLF" {
        (Get-Content -Path $test.MdxFile -Raw) -match "`r`n" | Should -Be $False
    }

    It "Content of generated mdx file is identical to that of expected fixture" {
        $generatedMdx | Should -BeExactly $expectedMdx
    }
}
