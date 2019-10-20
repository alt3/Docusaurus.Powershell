function New-DocusaurusHelp() {
    <#
        .SYNOPSIS
            Generates Get-Help documentation in Docusaurus compatible `.mdx` format.

        .DESCRIPTION
            The `New-DocusaurusHelp` cmdlet generates Get-Help documentation in Docusaurus
            compatible format by creating an `.mdx` file for each command exported by
            the module, then enriching that file with command specific front matter
            variables.

            The cmdlet also creates a `docusaurus.powershell.sidebar.js` file
            containing a list of all documented commands, for easy integration
            into the Docusaurus website sidebar.

        .OUTPUTS
            System.Object

        .EXAMPLE
            New-DocusaurusHelp -Module Alt3.Docusaurus.Powershell -OutputFolder .\docusaurus\docs\ -EditUrl "https://github.com/alt3/Docusaurus.Powershell/edit/master/source/Public"

        .PARAMETER Module
            Specifies the module this cmdlet will generate Docusaurus documentation for.

            You may specify a module name, a `.psd1` file or a `.psm1` file.

        .PARAMETER OutputFolder
            Specifies the folder where the Docusaurus Get-Help documentation will be created.

        .PARAMETER EditUrl
            Specifies the URL prefixed to all Docusaurus `custom_edit_url` front matter variables.

        .PARAMETER Monolithic
            Use this optional argument if the Powershell module source is monolithic.

            Will point all `custom_edit_url` front matter variables to the `.psm1` file.

        .NOTES
            Please note that Docusaurus v2 is an early and alpha version, just like this module.

        .LINK
            https://docusaurus.io/

        .LINK
            https://github.com/PowerShell/platyPS
    #>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True)][string]$Module,
        [Parameter(Mandatory = $True)][string]$OutputFolder,
        [Parameter(Mandatory = $True)][string]$EditUrl,
        [switch]$Monolithic # pass to edit a single pm file
    )

    # make sure the passed module is valid
    if (Test-Path($Module)) {
        Import-Module $Module -Force -Global
        $Module = [System.IO.Path]::GetFileNameWithoutExtension($Module)
    }

    if (-Not(Get-Module -Name $Module)) {
        $Module = $Module
        throw "New-DocusaurusHelp: Specified module '$Module' is not loaded"
    }

    # generate PlatyPs markdown files
    $markdownFiles = New-MarkdownHelp -Module $Module -OutputFolder $OutputFolder -Force

    # update generated markdown file(s) to make them Docusaurus compatible
    ForEach ($markdownFile in $markdownFiles) {
        $customEditUrl = GetCustomEditUrl -Module $Module -MarkdownFile $markdownFile -EditUrl $EditUrl -Monolithic:$Monolithic

        UpdateContentFrontMatter -MarkdownFile $markdownFile -CustomEditUrl $customEditUrl
        RemoveContentHeader1 -MarkdownFile $markdownFile
        UpdateContentPowershellCodeBlocks -MarkdownFile $markdownFile
        UpdateContentBackticks -MarkdownFile $markdownFile

        # rename to .mdx
        $mdxFilePath = GetMdxFilePath -MarkdownFile $markdownFile
       Move-Item -Path $markdownFile.FullName -Destination $mdxFilePath -Force | Out-Null

        # output .mdx item so end-user can post-process files as they see fit
       Get-Item $mdxFilePath
    }

    # generate the `.js` file used for the docusaurus sidebar
    NewSidebarIncludeFile -MarkdownFiles $markdownFiles -OutputFolder $OutputFolder
}
