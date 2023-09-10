BeforeDiscovery {
    if (-not(Get-Module Alt3.Docusaurus.Powershell)) {
        throw "Required module 'Alt3.Docusaurus.Powershell' is not loaded."
    }
}

BeforeAll {
    . "$((Get-Item -Path $PSCommandPath).Directory.Parent.FullName)/Bootstrap.ps1" -TestFolder (Get-Item -Path $PSCommandPath)

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    $DummyMarkdownFile = New-Item -Path (Join-Path $test.TempFolder -ChildPath "Get-DummyCommand.md") -Force

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    $DummyModuleFile = New-Item -Path (Join-Path $test.TempFolder -ChildPath "DummyModule.md") -Force
}

Describe "Unit test for private function GetCustomEditUrl" {
    It "Dummy markdown file created for test should exist" {
        $DummyMarkdownFile | Should -Exist
    }

    It "Dummy module created for test should exist" {
        $dummyModuleFile | Should -Exist
    }

    It "Returns `$null when omitting optional argument -EditUrl" {
        InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $DummyMarkdownFile } {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile $MarkdownFile | Should -BeNullOrEmpty
        }
    }

    It "Returns string ""null"" when using -EditUrl ""null""" {
        InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $DummyMarkdownFile } {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile $MarkdownFile -EditUrl "null" | Should -Be "null"
        }
    }

    It "Produces the correct URL when passing no trailing slash" {
        InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $DummyMarkdownFile } {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile $MarkdownFile -EditUrl "https://without.slash.com" |
            Should -Be "https://without.slash.com/Get-DummyCommand.ps1"
        }
    }

    It "Produces the correct URL when passing a single trailing slash" {
        InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $DummyMarkdownFile } {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile $MarkdownFile -EditUrl "https://with.slash.com/" |
            Should -Be "https://with.slash.com/Get-DummyCommand.ps1"
        }
    }

    It "Produces the correct URL when passing multiple trailing slashes" {
        InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $DummyMarkdownFile } {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile $MarkdownFile -EditUrl "https://with.slashes.com//" |
            Should -Be "https://with.slashes.com/Get-DummyCommand.ps1"
        }
    }

    Context "when not using -Monolithic" {
        It "Uses markdown file name to generate URL pointing to the correlating .ps1 (function/command) source file" {
            InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $DummyMarkdownFile } {
                GetCustomEditUrl -Module "DummyModule" -MarkdownFile $MarkdownFile -EditUrl "https://site.com" |
                Should -Be "https://site.com/Get-DummyCommand.ps1"
            }
        }
    }

    Context "when using -Monolithic" {
        It "Uses the module file name without extension to generate URL pointing to the correlating .psm1 (module) source file" {
            InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $DummyMarkdownFile; ModuleFile = $DummyModuleFile } {
                GetCustomEditUrl -Module $ModuleFile -MarkdownFile $MarkdownFile -EditUrl "https://site.com" -Monolithic |
                Should -Be "https://site.com/DummyModule.psm1"
            }
        }

        It "Otherwise simply uses the passed module name string to generate URL pointing to the correlating .psm1 (module) source file" {
            InModuleScope Alt3.Docusaurus.Powershell -Parameters @{MarkdownFile = $DummyMarkdownFile } {
                GetCustomEditUrl -Module Microsoft.PowerShell.Management -MarkdownFile $MarkdownFile -EditUrl "https://site.com" -Monolithic |
                Should -Be "https://site.com/Microsoft.PowerShell.Management.psm1"
            }
        }
    }
}
