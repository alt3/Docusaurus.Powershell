BeforeAll {
    # create dummy markdown file
    $markdownFilePath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'Dummy-PesterCommand.md'
    "Dummy markdown for testing GetCustomEditUrl" | Out-File -FilePath $markdownFilePath
    $markdownFile = Get-Item -Path $markdownFilePath

    # create dummy module
    $modulePath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'DummyModule.psm1'
    "Dummy markdown for testing GetCustomEditUrl" | Out-File -FilePath $modulePath
    $module = Get-Item -Path $modulePath
}

Describe "Private$([IO.Path]::DirectorySeparatorChar)GetCustomEditUrl" {
    It "Dummy markdown file created for test should exist" {
        $markdownFilePath | Should -Exist
    }

    It "Dummy module created for test should exist" {
        $modulePath | Should -Exist
    }

    It "Returns `$null when omitting optional argument -EditUrl" {
        InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $markdownFile } {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile $MarkdownFile | Should -BeNullOrEmpty
        }
    }

    It "Returns string ""null"" when using -EditUrl ""null""" {
        InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $markdownFile } {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile $markdownFile -EditUrl "null" | Should -Be "null"
        }
    }

    Context "for non-monolithic modules" {
        It "Uses markdown file name to generate URL pointing to the correlating .ps1 (function) source file when using -EditUrl ""https://site.com""" {
            InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $markdownFile } {
                GetCustomEditUrl -Module "DummyModule" -MarkdownFile $markdownFile -EditUrl "https://site.com" |
                Should -Be "https://site.com/Dummy-PesterCommand.ps1"
            }
        }
    }


    Context "for monolithic repos" {
        It "Uses markdown file name to generate URL pointing to the correlating .psm1 (module) source file when using -EditUrl ""https://site.com"" -Monolithic" {
            InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $markdownFile; Module = $module } {
                GetCustomEditUrl -Module $module -MarkdownFile $markdownFile -EditUrl "https://site.com" -Monolithic |
                Should -Be "https://site.com/DummyModule.psm1"
            }
        }

        It "Or simply uses the passed module name to generate URL pointing to the correlating .psm1 (module) source file when using -EditUrl ""https://site.com"" -Monolithic" {
            InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $markdownFile; Module = $module } {
                GetCustomEditUrl -Module Microsoft.PowerShell.Management -MarkdownFile $markdownFile -EditUrl "https://site.com" -Monolithic |
                Should -Be "https://site.com/Microsoft.PowerShell.Management.psm1"
            }
        }
    }
}

AfterAll {
    Remove-Item -Path $markdownFilePath
    Remove-Item -Path $modulePath
}
