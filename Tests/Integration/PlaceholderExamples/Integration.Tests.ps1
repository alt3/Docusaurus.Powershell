BeforeDiscovery {
    if (-not(Get-Module Alt3.Docusaurus.PowerShell)) {
        throw "Required module 'Alt3.Docusaurus.Powershell' is not loaded."
    }
}

BeforeAll {
    . "$((Get-Item -Path $PSCommandPath).Directory.Parent)/Bootstrap.ps1" -TestFolder (Get-Item -Path $PSCommandPath)
    Import-Module $test.Module -Force -DisableNameChecking -Verbose:$False -Scope Global

    # generate and read default mdx and thus with placeholder examples
    InModuleScope Alt3.Docusaurus.PowerShell -Parameters @{testModule = $test.Module; tempFolder = $test.TempFolder } {
        New-DocusaurusHelp -Module $testModule -DocsFolder $tempFolder
    }

    $generatedMdxWithPlaceholders = Get-Content -Path $test.MdxFile
    $expectedMdxWithPlaceholders = Get-Content (Join-Path -Path $test.Folder -ChildPath "Expected.WithPlaceholders.mdx")

    # generate and read mdx using -NoPlaceHolders
    InModuleScope Alt3.Docusaurus.PowerShell -Parameters @{testModule = $test.Module; tempFolder = $test.TempFolder } {
        New-DocusaurusHelp -Module $testModule -DocsFolder $tempFolder -NoPlaceholderExamples
    }

    $generatedMdxWithoutPlaceholders = Get-Content -Path $test.MdxFile
    $expectedMdxWithoutPlaceholders = Get-Content (Join-Path -Path $test.Folder -ChildPath "Expected.WithoutPlaceholders.mdx")
}

Describe "Integration Test for PlatyPS generated placeholder examples" {
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
