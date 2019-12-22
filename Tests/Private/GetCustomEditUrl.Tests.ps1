Describe "Private$([IO.Path]::DirectorySeparatorChar)GetCustomEditUrl" {
    Import-Module Alt3.Docusaurus.Powershell -DisableNameChecking -Verbose:$False

    # up
    $markdownFilePath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'Dummy-PesterCommand.md'
    $dummyModulePath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'DummyModule.psm1'


    "Dummy markdown" | Out-File -FilePath $markdownFilePath
    if (-Not(Test-Path -Path $markdownFilePath)) {
        throw "temporary markdown file was not created"
    }

    "Dummy module" | Out-File -FilePath $dummyModulePath
    if (-Not(Test-Path -Path $dummyModulePath)) {
        throw "temporary module file was not created"
    }

    ${global:markdownFileItem} = Get-Item -Path $markdownFilePath
    ${global:dummyModuleFileItem} = Get-Item -Path $dummyModulePath

    # the actual tests
    Context 'when optional -EditUrl argument is not used' {
        $customEditUrl = InModuleScope Alt3.Docusaurus.Powershell {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile ${global:markdownFileItem}
        }

        It "simply returns null" {
            $customEditUrl | Should -Be $null
        }
    }

    Context 'for non-monolithic modules' {
        $customEditUrl = InModuleScope Alt3.Docusaurus.Powershell {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile ${global:markdownFileItem} -EditUrl "https://dummy.com"
        }

        It "generates a link pointing to a ps1 source file with same name as the markdown file" {
            $customEditUrl | Should -Be 'https://dummy.com/Dummy-PesterCommand.ps1'
        }
    }

    Context 'for monolithic modules' {
        # ---------------------------------------------------------------------
        # passed module resolves to a file
        # ---------------------------------------------------------------------
        $customEditUrl = InModuleScope Alt3.Docusaurus.Powershell {
            GetCustomEditUrl -Module ${global:dummyModuleFileItem} -MarkdownFile ${global:markdownFileItem} -EditUrl "https://dummy.com" -Monolithic
        }

        It "generates a link pointing to a psm1 source file with same name as the (file-resolvable) module" {
            $customEditUrl | Should -Be 'https://dummy.com/DummyModule.psm1'
        }

        # ---------------------------------------------------------------------
        # passed module resolves to a loaded/imported module
        # ---------------------------------------------------------------------
        $customEditUrl = InModuleScope Alt3.Docusaurus.Powershell {
            GetCustomEditUrl -Module Microsoft.PowerShell.Management -MarkdownFile ${global:markdownFileItem} -EditUrl "https://dummy.com" -Monolithic
        }

        It "generates a link pointing to a psm1 source file with same name as the (imported/loaded) module" {
            $customEditUrl | Should -Be 'https://dummy.com/Microsoft.Powershell.Management.psm1'
        }

        # ---------------------------------------------------------------------
        # passed module does not resolve to a file AND is not loaded/imported
        # ---------------------------------------------------------------------
        $customEditUrl = InModuleScope Alt3.Docusaurus.Powershell {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile ${global:markdownFileItem} -EditUrl "https://dummy.com" -Monolithic
        }

        It "generates a link pointing to a psm1 source file with same name as the (non-resolvable) module" {
            $customEditUrl | Should -Be 'https://dummy.com/DummyModule.psm1'
        }
    }

    # down
    Remove-Item -Path ${global:markdownFileItem}
    Remove-Item -Path ${global:dummyModuleFileItem}
}
