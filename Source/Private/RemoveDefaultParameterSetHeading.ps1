function RemoveDefaultParameterSetHeading() {
    <#
        .SYNOPSIS
            Removes the `### __AllParameterSets` heading PlatyPS generates in the SYNTAX
            section for commands without named parameter sets.

        .NOTES
            Headings for named parameter sets are left untouched.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $content = $content -replace '### __AllParameterSets\n\n', ''

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
