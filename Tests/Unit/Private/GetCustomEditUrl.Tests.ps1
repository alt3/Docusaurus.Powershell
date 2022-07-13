BeforeAll {
    . "$((Get-Item -Path $PSCommandPath).Directory.Parent.FullName)/Bootstrap.ps1" -TestFolder (Get-Item -Path $PSCommandPath)

    $DummyMarkdownFile = New-Item -Path (Join-Path $test.TempFolder -ChildPath "Get-DummyCommand.md") -Force
    $DummyModuleFile = New-Item -Path (Join-Path $test.TempFolder -ChildPath "DummyModule.md") -Force
}

Describe "Unit test for private function GetCustomEditUrl" {
    It "Returns `$null when omitting optional argument -EditUrl" {
        GetCustomEditUrl -Module "DummyModule" -MarkdownFile $DummyMarkdownFile | Should -BeNullOrEmpty
    }

    It "Returns string ""null"" when using -EditUrl ""null""" {
        GetCustomEditUrl -Module "DummyModule" -MarkdownFile $DummyMarkdownFile -EditUrl "null" | Should -Be "null"
    }

    It "Produces the correct URL when passing no trailing slash" {

        GetCustomEditUrl -Module "DummyModule" -MarkdownFile $DummyMarkdownFile -EditUrl "https://without.slash.com" |
        Should -Be "https://without.slash.com/Get-DummyCommand.ps1"
    }

    It "Produces the correct URL when passing a single trailing slash" {
        GetCustomEditUrl -Module "DummyModule" -MarkdownFile $DummyMarkdownFile -EditUrl "https://with.slash.com/" |
        Should -Be "https://with.slash.com/Get-DummyCommand.ps1"
    }

    It "Produces the correct URL when passing multiple trailing slashes" {
        GetCustomEditUrl -Module "DummyModule" -MarkdownFile $DummyMarkdownFile -EditUrl "https://with.slashes.com//" |
        Should -Be "https://with.slashes.com/Get-DummyCommand.ps1"
    }

    Context "when not using -Monolithic" {
        It "Uses markdown file name to generate URL pointing to the correlating .ps1 (function/command) source file" {
            GetCustomEditUrl -Module "DummyModule" -MarkdownFile $DummyMarkdownFile -EditUrl "https://site.com" |
            Should -Be "https://site.com/Get-DummyCommand.ps1"
        }
    }

    Context "when using -Monolithic" {
        It "Uses the module file name without extension to generate URL pointing to the correlating .psm1 (module) source file" {
            GetCustomEditUrl -Module $DummyModuleFile -MarkdownFile $DummyMarkdownFile -EditUrl "https://site.com" -Monolithic |
            Should -Be "https://site.com/DummyModule.psm1"
        }

        It "Otherwise simply uses the passed module name string to generate URL pointing to the correlating .psm1 (module) source file" {
            GetCustomEditUrl -Module Microsoft.PowerShell.Management -MarkdownFile $DummyMarkdownFile -EditUrl "https://site.com" -Monolithic |
            Should -Be "https://site.com/Microsoft.PowerShell.Management.psm1"
        }
    }
}

