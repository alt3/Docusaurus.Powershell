# IndentLineWithOpeningBracket

This test ensures that this function:

- Corrects indentation for lines:
    - That end with an opening curly bracket
    - That are not yet indented at all (first char at position 0)
    - Are indented incorrectly
- By comparing indentation of the line below
- And recalculating indentation if things are amiss

## Why?

Required because PlatyPS sometimes gets things wrong when parsing complex code
examples like the example below where the line with `It` should have been indented.

```txt
    ### EXAMPLE 1
    ```
    ```powershell
    Describe "Validate important file" {
        BeforeAll {
            $samplePath = "$([IO.Path]::GetTempPath())/$([Guid]::NewGuid()).txt"
            Write-Host $samplePath
            1..100 | Set-Content -Path $samplePath
        }
    ```

    It "File Contains 100 lines" {
            @(Get-Content $samplePath).Count | Should -Be 100
        }

        It "First ten lines should be 1 -\> 10" {
            @(Get-Content $samplePath -TotalCount 10) | Should -Be @(1..10)
        }

        AfterAll {
            Remove-Item -Path $samplePath
        }
    }
    \`\`\`

```

## Additional information:

- https://github.com/pester/Pester/issues/2195
- Link to regex in function [source file](https://github.com/alt3/Docusaurus.Powershell/blob/main/Source/Private/IndentLineWithOpeningBracket.ps1#L17)
