function Test-RemoveBlankLinesAboveClosingBracket {
    <#
    .SYNOPSIS
    Dummy module to ensure that black lines ABOVE a line ending with
    a closing curly bracket are removed.

    .EXAMPLE
    ```powershell
    function SomeFunction {
    Write-Host "Alt3-module should not change this correct example"
    }
    ```

    .EXAMPLE
    ```powershell
    function SomeFunction {
    Write-Host "Alt3-module should remove single blank line below"

    }
    ```

    .EXAMPLE
    ```powershell
    function SomeFunction {
    Write-Host "Alt3-module should remove single blank lines below"


    }
    ```

    .EXAMPLE
    ```powershell
        It "Bug: that was happening with Test Export-Clixml" {
            Get-ChildItem | Export-Clixml -Path $filePath
            $dir = Import-Clixml -Path $filePath
            # Alt3-module should remove single blank line below

        }
    ```

    .EXAMPLE
    ```powershell
    Describe  {
        Write-Host "Bug: that was happening with InModuleScope.mdx"

        It "Test Export-CSV" {
            Get-ChildItem | Export-CSV -Path $filePath -NoTypeInformation
            $dir = Import-CSV -Path $filePath
            # Alt3-Module should remove multiple blank lines below


    }
    ```
#>
}
