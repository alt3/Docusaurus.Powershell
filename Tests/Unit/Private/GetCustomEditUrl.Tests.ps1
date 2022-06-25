BeforeDiscovery {
    if (-not(Get-Module Alt3.Docusaurus.PowerShell)) {
        throw "Required module 'Alt3.Docusaurus.Powershell' is not loaded."
    }
}

BeforeAll {
    # create dummy markdown file for this test
    $markdownFilePath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'Dummy-Command.md'
    "Dummy markdown for testing GetCustomEditUrl" | Out-File -FilePath $markdownFilePath
    $markdownFile = Get-Item -Path $markdownFilePath

    # create dummy module for this test
    $modulePath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'DummyModule.psm1'
    "Dummy markdown for testing GetCustomEditUrl" | Out-File -FilePath $modulePath
    $module = Get-Item -Path $modulePath
}

Describe "Private function GetCustomEditUrl" {
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

    It "Produces the correct URL when passing no trailing slash" {
        InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $markdownFile } {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile $markdownFile -EditUrl "https://without.slash.com" |
            Should -Be "https://without.slash.com/Dummy-Command.ps1"
        }
    }

    It "Produces the correct URL when passing a single trailing slash" {
        InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $markdownFile } {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile $markdownFile -EditUrl "https://with.slash.com/" |
            Should -Be "https://with.slash.com/Dummy-Command.ps1"
        }
    }

    It "Produces the correct URL when passing multiple trailing slashes" {
        InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $markdownFile } {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile $markdownFile -EditUrl "https://with.slashes.com//" |
            Should -Be "https://with.slashes.com/Dummy-Command.ps1"
        }
    }

    Context "when not using -Monolithic" {
        It "Uses markdown file name to generate URL pointing to the correlating .ps1 (function) source file" {
            InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $markdownFile } {
                GetCustomEditUrl -Module "DummyModule" -MarkdownFile $markdownFile -EditUrl "https://site.com" |
                Should -Be "https://site.com/Dummy-Command.ps1"
            }
        }
    }

    Context "when using -Monolithic" {
        It "Uses markdown file name to generate URL pointing to the correlating .psm1 (module) source file" {
            InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $markdownFile; Module = $module } {
                GetCustomEditUrl -Module $module -MarkdownFile $markdownFile -EditUrl "https://site.com" -Monolithic |
                Should -Be "https://site.com/DummyModule.psm1"
            }
        }

        It "Otherwise simply uses the passed module name to generate URL pointing to the correlating .psm1 (module) source file" {
            InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $markdownFile; Module = $module } {
                GetCustomEditUrl -Module Microsoft.PowerShell.Management -MarkdownFile $markdownFile -EditUrl "https://site.com" -Monolithic |
                Should -Be "https://site.com/Microsoft.PowerShell.Management.psm1"
            }
        }
    }
}

AfterAll {
    if (Get-Module Alt3.Docusaurus.PowerShell) {
        Remove-Item -Path $markdownFilePath
        Remove-Item -Path $modulePath
    }
}
