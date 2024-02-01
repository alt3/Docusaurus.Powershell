<#
    .SYNOPSIS
    DRY helper for logic shared by all unit tests.

    .NOTES
    Every unit test follows the same logic:
    - Imports the Alt-module
    - Then uses InModuleScope testing of the function (as required for code coverage)

    .NOTES
    Each test has a correlating folder in $env:Temp named after the
    test containing all output produced by the test (if any)

#>
#Requires -Version 7.4.1

param(
    [Parameter(Mandatory = $True)][System.IO.FileInfo]$TestFolder
)

$test = @{
    Name   = $TestFolder.Name.Replace(".Tests.ps1", "") # e.g. GetCustomEditUrl
    Folder = $TestFolder.Directory.FullName
    Type   = $TestFolder.Directory.Name # e.g. Private or Public
    TempFolder = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath $TestFolder.Name.Replace(".Tests.ps1", "")
}

# remove previous folder in $env:Temp
if (Test-Path -Path $test.TempFolder) {
    Remove-Item $test.TempFolder -Recurse -Force
}
