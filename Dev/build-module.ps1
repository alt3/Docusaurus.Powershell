<#
    .SYNOPSIS
    Build the module, then import it
#>

Build-Module -SourcePath ".\source" -VersionedOutputDirectory

Import-Module ".\output\0.1.0\Alt3.Docusaurus.Powershell.psd1" -Force

New-DocusaurusHelp -Module Alt3.Docusaurus.Powershell -OutputFolder .\docusaurus\docs\ -EditUrl "https://github.com/alt3/Docusaurus.Powershell/edit/master/source/Public"

#New-DocusaurusHelp -Module ".\output\0.1.0\Alt3.Docusaurus.Powershell.psd1" -OutputFolder .\docusaurus\docs\ -EditUrl "https://github.com/alt3/Docusaurus.Powershell/edit/master/source/Public"





