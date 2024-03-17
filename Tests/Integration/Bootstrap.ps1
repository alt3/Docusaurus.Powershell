<#
    .SYNOPSIS
    DRY helper for logic shared by all integration tests.

    .NOTES
    Every integration test follows the same logic:
    - Imports the TestModule
    - Uses the Alt-module to generate Docusaurus files in $env:Temp
    - Makes sure the generated files exists
    - Compares the generated mdx file to the expected mdx

    .NOTES
    Each test has a correlating folder in $env:Temp named after the
    test containing all output produced by the test (if any)
#>
#Requires -Version 7.4

param(
    [Parameter(Mandatory = $True)][System.IO.FileInfo]$TestFolder
)

$test = @{
    Name       = $TestFolder.Directory.Name
    Folder     = $TestFolder.Directory
    Module     = Join-Path -Path $TestFolder.Directory -ChildPath "$($TestFolder.Directory.Name).psm1"
    TempFolder = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "Alt3.Docusaurus.Powershell" |
        Join-Path -ChildPath $TestFolder.Directory.Name
    MdxFile    = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "Alt3.Docusaurus.Powershell" |
        Join-Path -ChildPath $TestFolder.Directory.Name |
        Join-Path -ChildPath "commands" |
        Join-Path -ChildPath "Test-$($TestFolder.Directory.Name).mdx"
}

# unload the Test-Module
if (Get-Module -Name "TestModule") {
    Remove-Module -Name "TestModule" -Force -Verbose:$False
}

# remove any previous folders in $env:Temp
if ((Get-Module Alt3.Docusaurus.Powershell) -and (Test-Path -Path $test.TempFolder)) {
    Remove-Item $test.TempFolder -Recurse -Force
}
