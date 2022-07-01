<#
    .SYNOPSIS
    DRY helper for test variables used by all tests.

    .NOTES
    Every integration test follows the same logic:
    - Imports the TestModule
    - Uses the Alt-module to generate Docusaurus files in $env:Temp
    - Makes sure the generated files exists
    - Compares the generated mdx file to the expected mdx
#>
param(
    [Parameter(Mandatory = $True)][System.IO.FileInfo]$TestFolder
)

$test = @{
    Name       = $TestFolder.Directory.Name
    Folder     = $TestFolder.Directory
    Module     = Join-Path -Path $TestFolder.Directory -ChildPath "TestModule.psm1"
    TempFolder = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath $TestFolder.Directory.Name
    MdxFile    = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath $TestFolder.Directory.Name |
    Join-Path -ChildPath "commands" |
    Join-Path -ChildPath "Test-$($TestFolder.Directory.Name).mdx"
}
