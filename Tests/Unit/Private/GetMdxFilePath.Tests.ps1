Describe "Private$([IO.Path]::DirectorySeparatorChar)GetMdxFilePath" {
    if (-not(Get-Module Alt3.Docusaurus.Powershell)) {
        Import-Module Alt3.Docusaurus.Powershell -DisableNameChecking -Verbose:$False
    }

    # up
    $markdownFilePath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'pester-markdown.md'

    "Dummy file" | Out-File -FilePath $markdownFilePath
    if (-Not(Test-Path -Path $markdownFilePath)) {
        throw "temporary markdown file was not created"
    }

    ${global:markdownFileItem} = Get-Item -Path $markdownFilePath

    # the actual tests
    $mdxFilePath = InModuleScope Alt3.Docusaurus.Powershell {
        GetMdxFilePath -MarkdownFile ${global:markdownFileItem}
    }

    It "does not change the filename" {
        [System.IO.Path]::GetFileNameWithoutExtension($mdxFilePath) | Should -Be 'pester-markdown'
    }

    It "does change the file extension to .mdx" {
        [System.IO.Path]::GetExtension($mdxFilePath) | Should -Be '.mdx'
    }

    It "does not change the full path"  {
        $mdxFilePath.Substring(0, $mdxFilePath.length - 1) | Should -Be ${global:markdownFileItem}.FullName
    }

    # down
    Remove-Item -Path ${global:markdownFileItem}
}
