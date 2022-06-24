#Region: Build Test Environment
$ModuleName = "Issue97"
$ModulePath = "C:\Temp\Issue97"

If (-not (Test-Path -Path $ModulePath)) {
    [void](New-Item -Path $ModulePath -ItemType Directory -Force)
}

@'
Function Show-Issue97 {
    <#
        .SYNOPSIS
            SYNOPSIS
        .DESCRIPTION
            DESCRIPTION
        .EXAMPLE
            "Input" | ForEach-Object {Show-Issue97 -Name $_}
    #>
    Param(
        [string]$Name
    )

    Process {
        $Name
    }
}
'@ | Set-Content -Path "$($ModulePath)\$($ModuleName).psm1"
New-ModuleManifest -Path "$($ModulePath)\$($ModuleName).psd1" -ModuleVersion 1.0.0 -RootModule "$($ModuleName).psm1" -FunctionsToExport "Show-Issue97"
Import-Module -Name "$($ModulePath)\$($ModuleName).psd1"
#Get-help Show-Issue97 -Examples
#EndRegion: Build Test Environment

#Region: Test Issue97
# Import-Module -Name PlatyPS, Alt3.Docusaurus.PowerShell, Pester

$ExpectedResult = @'
---
id: Show-Issue97
title: Show-Issue97
hide_title: false
hide_table_of_contents: false
---

## SYNOPSIS

SYNOPSIS

## SYNTAX

```powershell
Show-Issue97 [[-Name] <String>]
```

## DESCRIPTION

DESCRIPTION

## EXAMPLES

### EXAMPLE 1

```powershell
"Input" | ForEach-Object {Show-Issue97 -Name $_}
```

## PARAMETERS

### -Name

{{ Fill Name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

'@

New-DocusaurusHelp -Module "$($ModulePath)\$($ModuleName).psd1" -DocsFolder "$($ModulePath)\docs"
$Result = Get-Content "$($ModulePath)\docs\commands\show-Issue97.mdx" -Raw

$Result | Should -Be $ExpectedResult
#EndRegion: Test Issue97
