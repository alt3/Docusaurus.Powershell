function New-DocusaurusHelp() {
    <#
        .SYNOPSIS
            Generate Docusaurus compatible markdown files.

        .OUTPUTS
            System.Object

            Identical to the type of object returned by Get-ChildItem.

        .EXAMPLE
            New-DocusaurusHelp -Module <YourModuleName>

        .EXAMPLE
            New-DocusaurusHelp -Module <path-to-your-module.psm1>

        .NOTES
            - @todo: support all PlatyPS params https://github.com/PoshCode/poshcode.github.io/blob/a9a4a3271b0b6dc1b9558a0940c2bac7a4283437/scripts/4379.ps1
            - @todo: add -Verbose
    #>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True)][string]$Module, # name OR full path to .psd1
        [Parameter(Mandatory = $True)][string]$OutputFolder,
        [Parameter(Mandatory = $True)][string]$EditUrl,
        [switch]$Monolithic # pass to edit a single pm file
    )

    # import latest version of module to be documented
    Import-Module -Name $Module -Force -Global

    # generate PlatyPs markdown files
    $markdownFiles = New-MarkdownHelp -Module Alt3.Powershell.MacriumReflect -OutputFolder $OutputFolder -Force

    # update generated markdown file(s) to make them Docusaurus compatible
    ForEach ($markdownFile in $markdownFiles) {
        $customEditUrl = getCustomEditUrl -Module $Module -MarkdownFile $markdownFile -EditUrl $EditUrl -Monolithic:$Monolithic

        replaceMarkdownHeader -MarkdownFile $markdownFile -CustomEditUrl $customEditUrl
        setCodeBlockLanguage -MarkdownFile $markdownFile

        # rename to .mdx
        $mdxFilePath = getMdxFilePath -MarkdownFile $markdownFile
        Move-Item -Path $markdownFile.FullName -Destination $mdxFilePath -Force | Out-Null

        # output .mdx item so end-user can post-process files as they see fit
        Get-Item $mdxFilePath
    }

    # generate the `.js` file used for the docusaurus sidebar
    generateSidebarIncludeFile -MarkdownFiles $markdownFiles -OutputFolder $OutputFolder
}
