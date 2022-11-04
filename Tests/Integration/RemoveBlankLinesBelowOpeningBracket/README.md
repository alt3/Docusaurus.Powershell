# IndentLineWithOpeningBracket

This test ensures that this function:

- Removes blank line(s) below lines ending with an opening curly bracket

## Why?

Required because PlatyPS sometimes gets things wrong when parsing complex code
examples like the example below:

```txt
    ```powershell
    {

        Write-Host "Alt3-module should remove the blank line above
    }
    ```
```

## Additional information:

- Link to regex in function [source file](https://github.com/alt3/Docusaurus.Powershell/blob/main/Source/Private/RemoveEmptyLinesBelowOpeningBracket.ps1#L10)
