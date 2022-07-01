function Test-IndentLineWithOpeningBracket {
    <#
    .SYNOPSIS
    Dummy module to ensure that indentation is fixed correctly (but only for lines that
    are ending with an opening curly bracket AND with first char at position 0).

    .EXAMPLE
    ```powershell
    InModuleScope MyModule {
        Describe 'Alt-3 module should not break this correct indentation' {
            It 'Tests the Private function' {
                PrivateFunction | Should -Be $true
            }
        }
    }
    ```

    .EXAMPLE
    ```powershell
    Describe "Alt3-module should not break this correct indentation" {
        BeforeAll {
            $$samplePath = "$$([IO.Path]::GetTempPath())/$$([Guid]::NewGuid()).txt"
            Write-Host $$samplePath
            1..100 | Set-Content -Path $$samplePath
        }
    }
    ```

    .EXAMPLE
    ```powershell
    # Alt-3 module should not break this correct indentation
    function PublicFunction
    {
        # Does something
    }
    ```

    .EXAMPLE
    ```powershell
        It 'Alt3-Module should not break this correct indentation (this line should be untouched because first char not at position 0)'
            $SomeVar = 123
            InModuleScope 'MyModule' -Parameters @{ MyVar = $SomeVar } {
                $MyVar | Should -Be 123
            }
        }
    ```

    .EXAMPLE
    ```powershell
    It "Alt3-module should fix this incorrect indentation (to match line below)" {
            @(Get-Content $$samplePath).Count | Should -Be 100
        }
    ```

    .EXAMPLE
    ```powershell
    AfterEach {
            if (Test-Path $file) {
                # Alt3-module should fix incorrect indentation of AfterEach
            }
        }
    ```
#>
}
