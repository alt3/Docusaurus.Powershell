function New-DocusaurusHelp() {
    <#
        .SYNOPSIS
            Generates Get-Help documentation in Docusaurus compatible `.mdx` format.

        .DESCRIPTION
            The `New-DocusaurusHelp` cmdlet generates Get-Help documentation in Docusaurus
            compatible format by creating an `.mdx` file for each command exported by
            the module, enriched with command-specific front matter variables.

            Also creates a `sidebar.js` file for simplified integration into the Docusaurus sidebar menu.

        .OUTPUTS
            System.Object

        .EXAMPLE
            New-DocusaurusHelp -Module Alt3.Docusaurus.Powershell -EditUrl "https://github.com/alt3/Docusaurus.Powershell/edit/master/source/Public"

        .PARAMETER Module
            Specifies the module this cmdlet will generate Docusaurus documentation for.

            You may specify a module name, a `.psd1` file or a `.psm1` file.

        .PARAMETER OutputFolder
            Specifies the folder where the Docusaurus sidebar subfolder will be created.

            Optional, defaults to `docusaurus/docs`, case sensitive.

        .PARAMETER Sidebar
            Specifies the subfolder where the Get-Help `.mdx` files for the module will be created.

            Optional, defaults to `CmdLets`, case sensitive.

        .PARAMETER EditUrl
            Specifies the URL prefixed to all Docusaurus `custom_edit_url` front matter variables.

            Optional, defaults to `null`.

        .PARAMETER Exclude
            Optional array with command names to exclude.

        .PARAMETER MetaDescription
            Optional string that will be inserted into Docusaurus front matter to be used as `description` meta tag.

            If placeholder `%1` is detected in the string, it will be replaced by the command name.

        .PARAMETER Monolithic
            Use this optional argument if the Powershell module source is monolithic.

            Will point all `custom_edit_url` front matter variables to the `.psm1` file.

        .NOTES
            Please note that Docusaurus v2 is an early and alpha version, just like this module.

        .LINK
            https://v2.docusaurus.io/

        .LINK
            https://github.com/PowerShell/platyPS
    #>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True)][string]$Module,
        [Parameter(Mandatory = $False)][string]$OutputFolder = "docusaurus/docs",
        [Parameter(Mandatory = $False)][string]$Sidebar = "CmdLets",
        [Parameter(Mandatory = $False)][string]$EditUrl,
        [Parameter(Mandatory = $False)][array]$Exclude = @(),
        [Parameter(Mandatory = $False)][string]$MetaDescription,
        [switch]$Monolithic
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

    # markdown for the module will be isolated in a subfolder
    $markdownFolder = Join-Path -Path $OutputFolder -ChildPath $Sidebar

    # generate PlatyPs markdown files
    New-MarkdownHelp -Module $Module -OutputFolder $markdownFolder -Force | Out-Null

    # remove excluded files
    $Exclude | ForEach-Object {
        Remove-Item -Path (Join-Path -Path $markdownFolder -ChildPath "$($_).md")
    }

    # process remaining files
    $markdownFiles = Get-ChildItem -Path $markdownFolder -Filter *.md

    # update generated markdown file(s) to make them Docusaurus compatible
    ForEach ($markdownFile in $markdownFiles) {
        $customEditUrl = GetCustomEditUrl -Module $Module -MarkdownFile $markdownFile -EditUrl $EditUrl -Monolithic:$Monolithic

        SetMarkdownFrontMatter -MarkdownFile $markdownFile -CustomEditUrl $customEditUrl -MetaDescription $MetaDescription
        RemoveMarkdownHeaderOne -MarkdownFile $markdownFile
        UpdateMarkdownCodeBlocks -MarkdownFile $markdownFile
        UpdateMarkdownBackticks -MarkdownFile $markdownFile

        # rename to .mdx
        $mdxFilePath = GetMdxFilePath -MarkdownFile $markdownFile
        Move-Item -Path $markdownFile.FullName -Destination $mdxFilePath -Force | Out-Null

        # output .mdx item so end-user can post-process files as they see fit
        Get-Item $mdxFilePath
    }

    # generate the `.js` file used for the docusaurus sidebar
    NewSidebarIncludeFile -MarkdownFiles $markdownFiles -OutputFolder $markdownFolder -Sidebar $Sidebar
}
