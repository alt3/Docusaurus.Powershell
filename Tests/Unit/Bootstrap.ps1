<#
    .SYNOPSIS
    DRY helper for logic shared by all unit tests.

    .NOTES
    Every unit test follows the same logic:
    - Dot sources the source file belonging to the test
    - Mocks whatever commands are not relevant
    - Tests the imported function

#>
param(
    [Parameter(Mandatory = $True)][System.IO.FileInfo]$TestFolder
)

$test = @{
    Name   = $TestFolder.Name.Replace(".Tests.ps1", "") # e.g. GetCustomEditUrl
    Folder = $TestFolder.Directory.FullName
    Type   = $TestFolder.Directory.Name # e.g. Private or Public
    TempFolder = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath $TestFolder.Name.Replace(".Tests.ps1", "")
}

# find the correlating source file
$test.SourceFile = Join-Path -Path $TestFolder.Directory.Parent.Parent.Parent -ChildPath "Source" |
Join-Path -ChildPath $test.Type |
Join-Path -ChildPath "$($test.Name).ps1"

# dot source the source file
. $test.SourceFile

# remove previous folder in $env:Temp
if (Test-Path -Path $test.TempFolder) {
    Remove-Item $test.TempFolder -Recurse -Force
}

