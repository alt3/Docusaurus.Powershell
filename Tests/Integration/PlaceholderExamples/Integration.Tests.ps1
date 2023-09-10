BeforeDiscovery {
    if (-not(Get-Module Alt3.Docusaurus.Powershell)) {
        throw "Required module 'Alt3.Docusaurus.Powershell' is not loaded."
    }
}

BeforeAll {
    . "$((Get-Item -Path $PSCommandPath).Directory.Parent.FullName)/Bootstrap.ps1" -TestFolder (Get-Item -Path $PSCommandPath)
    Import-Module $test.Module -Force -DisableNameChecking -Verbose:$False -Scope Global

    # generate and read default mdx and thus with placeholder examples
    InModuleScope Alt3.Docusaurus.Powershell -Parameters @{testModule = $test.Module; tempFolder = $test.TempFolder } {
        New-DocusaurusHelp -Module $testModule -DocsFolder $tempFolder
    }

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    $generatedMdxWithPlaceholders = Get-Content -Path $test.MdxFile

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    $expectedMdxWithPlaceholders = Get-Content (Join-Path -Path $test.Folder -ChildPath "Expected.WithPlaceholders.mdx")

    # generate and read mdx using -NoPlaceHolders
    InModuleScope Alt3.Docusaurus.Powershell -Parameters @{testModule = $test.Module; tempFolder = $test.TempFolder } {
        New-DocusaurusHelp -Module $testModule -DocsFolder $tempFolder -NoPlaceholderExamples
    }

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    $generatedMdxWithoutPlaceholders = Get-Content -Path $test.MdxFile

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    $expectedMdxWithoutPlaceholders = Get-Content (Join-Path -Path $test.Folder -ChildPath "Expected.WithoutPlaceholders.mdx")
}

Describe "Integration test to ensure PlatyPS placeholder examples render as expected" {
    It "Mdx file generated for test should exist" {
        $test.MdxFile | Should -Exist
    }

    It "Mdx file generated for test should have content" {
        $generatedMdxWithPlaceholders | Should -Not -BeNullOrEmpty
    }

    It "Mdx file generated for test should not contain CRLF" {
        (Get-Content -Path $test.MdxFile -Raw) -match "`r`n" | Should -Be $False
    }

    It "Content of generated (default) mdx file is identical to that of expected fixture" {
        $generatedMdxWithPlaceholders | Should -BeExactly $expectedMdxWithPlaceholders
    }

    It "Content of generated mdx file (using -NoPlaceholderExamples) is identical to that of expected fixture" {
        $generatedMdxWithoutPlaceholders | Should -BeExactly $expectedMdxWithoutPlaceholders
    }
}
