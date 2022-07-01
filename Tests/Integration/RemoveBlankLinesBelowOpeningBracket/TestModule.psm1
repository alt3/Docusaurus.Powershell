function Test-RemoveBlankLinesBelowOpeningBracket {
    <#
    .SYNOPSIS
    Dummy module to ensure that black lines below lines ending with an
    opening curly bracket are removed.

    .EXAMPLE
    ```powershell
    function SomeFunction
    {
        Write-Host "Alt3-Module should not touch this correct example.
    }
    ```
    .EXAMPLE
    ```powershell
    function PesterIssue2195
    {

        Write-Host "Alt3-module should remove the single blank line above
    }
    ```

    .EXAMPLE
    ```powershell
    If ($var -eq $true) {



        Write-Host "Alt3-module should remove the multiple blank lines above
    }
    ```

    .EXAMPLE
    ```powershell
    Describe "Clean" {

        It "Alt3-module should remove the blank line above" {
            Clean | Should -Be "YOUR_EXPECTED_VALUE"
        }
    }
    ```

    .EXAMPLE
    ```powershell
    function Example21
    {

        Write-Host "Pester issue 2196: this line should have correct indentation and no whiteline above"
        if ($Negate) { $succeeded = -not $succeeded }
    }
    ```
#>
}
