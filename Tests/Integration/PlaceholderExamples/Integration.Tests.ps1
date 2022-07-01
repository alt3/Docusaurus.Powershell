BeforeDiscovery {
    if (-not(Get-Module Alt3.Docusaurus.PowerShell)) {
        throw "Required module 'Alt3.Docusaurus.Powershell' is not loaded."
    }
}

BeforeAll {
    . "$((Get-Item -Path $PSCommandPath).Directory.Parent)/Bootstrap.ps1" -TestFolder (Get-Item -Path $PSCommandPath)
    Import-Module $test.Module -Force -DisableNameChecking -Verbose:$False -Scope Global

    # generate default mdx and thus with placeholder examples
    InModuleScope Alt3.Docusaurus.PowerShell -Parameters @{testModule = $test.Module; tempFolder = $test.TempFolder } {
        New-DocusaurusHelp -Module $testModule -DocsFolder $tempFolder
    }

    $generatedMdxDefault = Get-Content -Path $test.MdxFile
    $expectedMdxDefault = Get-Content (Join-Path -Path $test.Folder -ChildPath "Expected.WithPlaceholders.mdx")

    # generate mdx and without placeholder examples using -NoPlaceHolders
    InModuleScope Alt3.Docusaurus.PowerShell -Parameters @{testModule = $test.Module; tempFolder = $test.TempFolder } {
        New-DocusaurusHelp -Module $testModule -DocsFolder $tempFolder -NoPlaceholderExamples
    }

    $generatedMdxNoPlaceholders = Get-Content -Path $test.MdxFile
    $expectedMdxNoPlaceholders = Get-Content (Join-Path -Path $test.Folder -ChildPath "Expected.WithoutPlaceholders.mdx")

    # # $renderedMdxFileDefault = Join-Path -Path $docsFolderDefault -ChildPath "commands" | Join-Path -ChildPath "Test-$testModuleName.mdx"
    # $renderedMdxDefault = Get-Content $renderedMdxFileDefault
    # $expectedMdxDefault = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "$testModuleName.DEFAULT.expected.mdx")

    # generate Docusaurus docs folder using the -NoPlaceholderExamples switch parameter
    # $docsFolderNoPlaceholders = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "$testModuleName-NoPlacehoders"
    # InModuleScope Alt3.Docusaurus.PowerShell -Parameters @{TestModulePath = $testModulePath; DocsFolder = $docsFolderNoPlaceholders } {
    #     New-DocusaurusHelp -Module $testModulePath -DocsFolder $DocsFolder -NoPlaceholderExamples
    # }

    # $renderedMdxFileNoPlaceholders = Join-Path -Path $docsFolderNoPlaceholders -ChildPath "commands" | Join-Path -ChildPath "Test-$testModuleName.mdx"
    # $renderedMdxNoPlaceholders = Get-Content $renderedMdxFileNoPlaceholders
    # $expectedMdxNoPlaceholders = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "$testModuleName.NOPLACEHOLDERS.expected.mdx")

}

Describe "Integration Test for PlatyPS generated placeholder examples" {
    It "Mdx file generated for test should exist" {
        $test.MdxFile | Should -Exist
    }

    It "Mdx file generated for test should not contain CRLF" {
        (Get-Content -Path $test.MdxFile -Raw) -match "`r`n" | Should -Be $False
    }

    It "Content of generated mdx file is identical to that of expected (default) fixture" {
        $generatedMdxDefault | Should -BeExactly $expectedMdxDefault
    }

    # It "Mdx file generated for testing DEFAULT should exist" {
    #     $test.MdxFile | Should -Exist
    # }

    # It "Content of DEFAULT generated mdx file is identical to that of expected fixture (with PlatyPS example placeholders)" {
    #     $renderedMdxDefault | Should -BeExactly $expectedMdxDefault
    # }

    # It "Generated DEFAULT mdx file does not contain CRLF" {
    #     (Get-Content -Path $renderedMdxFileDefault -Raw) -match "`r`n" | Should -Be $False
    # }

    # It "Mdx file generated for testing NOPLACEHOLDERS should exist" {
    #     $renderedMdxFileNoPlaceholders | Should -Exist
    # }

    # It "Content of NOPLACEHOLDERS generated mdx file is identical to that of expected fixture (without PlatyPS example placeholders)" {
    #     $renderedMdxNoPlaceholders | Should -BeExactly $expectedMdxNoPlaceholders
    # }

    # It "Generated NOPLACEHOLDERS mdx file does not contain CRLF" {
    #     (Get-Content -Path $renderedMdxFileNoPlaceholders -Raw) -match "`r`n" | Should -Be $False
    # }
}

AfterAll {
    if (Get-Module Alt3.Docusaurus.PowerShell) {
        # Remove-Item $docsFolderDefault -Recurse -Force
        # Remove-Item $docsFolderNoPlaceholders -Recurse -Force
    }
}
