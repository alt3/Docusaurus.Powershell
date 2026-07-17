BeforeDiscovery {
    if (-not(Get-Module Alt3.Docusaurus.Powershell)) {
        throw "Required module 'Alt3.Docusaurus.Powershell' is not loaded."
    }
}

BeforeAll {
    . "$((Get-Item -Path $PSCommandPath).Directory.Parent.FullName)/Bootstrap.ps1" -TestFolder (Get-Item -Path $PSCommandPath)
    Import-Module $test.Module -Force -DisableNameChecking -Verbose:$False -Scope Global

    # enrich the CommandHelp front matter like the advanced user workflow described
    # in https://github.com/alt3/Docusaurus.Powershell/issues/185
    $commandHelp = New-CommandHelp -CommandInfo (Get-Command Test-PreserveFrontMatter)
    $commandHelp.Metadata['description'] = 'User-enriched description: with yaml-hostile characters'
    $commandHelp.Metadata['image'] = 'https://example.com/social-card.png'

    # generate and read Docusaurus files in $env:Temp, -MetaDescription MUST NOT
    # overwrite the user-enriched description key
    InModuleScope Alt3.Docusaurus.Powershell -Parameters @{commandHelp = $commandHelp; tempFolder = $test.TempFolder } {
        New-DocusaurusHelp -CommandHelp $commandHelp -DocsFolder $tempFolder -MetaDescription 'Generated description for "%1" that should not appear'
    }

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    $generatedMdx = Get-Content -Path $test.MdxFile

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    $expectedMdx = Get-Content (Join-Path -Path $test.Folder -ChildPath "Expected.mdx")
}

Describe "Integration test to ensure user-enriched front matter keys are preserved" {
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
