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
            New-DocusaurusHelp -Module Alt3.Docusaurus.Powershell

            This example uses default settings to generate a Get-Help page for each command exported by
            the Alt3.Docusaurus.Powershell module.

        .EXAMPLE
            ```
            $arguments = @{
                Module = "Alt3.Docusaurus.Powershell"
                OutputFolder = "D:\my-project\docs"
                SideBar = "commands"
                Exclude = @(
                    "Get-SomeCommand"
                )
                MetaDescription = 'Help page for the Powershell command "%1"'
                MetaKeywords = @(
                    "Powershell"
                    "Documentation"
                )
            }

            New-DocusaurusHelp @arguments
            ```

            This example uses splatting to override default settings.

            See the list of Parameters below for all available overrides.

        .PARAMETER Module
            Specifies the module this cmdlet will generate Docusaurus documentation for.

            You may specify a module name, a `.psd1` file or a `.psm1` file.

        .PARAMETER OutputFolder
            Specifies the folder where the Docusaurus sidebar subfolder will be created.

            Optional, defaults to `docusaurus/docs`, case sensitive.

        .PARAMETER Sidebar
            Specifies the subfolder where the Get-Help `.mdx` files for the module will be created.

            Optional, defaults to `commands`, case sensitive.

        .PARAMETER Exclude
            Optional array with command names to exclude.

        .PARAMETER MetaDescription
            Optional string that will be inserted into Docusaurus front matter to be used as html meta tag 'description'.

            If placeholder `%1` is detected in the string, it will be replaced by the command name.

        .PARAMETER MetaKeywords
            Optional array of keywords inserted into Docusaurus front matter to be used as html meta tag `keywords`.

        .PARAMETER EditUrl
            Specifies the URL prefixed to all Docusaurus `custom_edit_url` front matter variables.

            Optional, defaults to `null`.

        .PARAMETER HideTitle
            Sets the Docusaurus front matter variable `hide_title`.

            Optional, defaults to `false`.

        .PARAMETER HideTableOfContents
            Sets the Docusaurus front matter variable `hide_table_of_contents`.

            Optional, defaults to `false`.

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
        [Parameter(Mandatory = $False)][string]$Sidebar = "commands",
        [Parameter(Mandatory = $False)][array]$Exclude = @(),
        [Parameter(Mandatory = $False)][string]$MetaDescription,
        [Parameter(Mandatory = $False)][array]$MetaKeywords = @(),
        [Parameter(Mandatory = $False)][string]$EditUrl,
        [switch]$HideTitle,
        [switch]$HideTableOfContents,
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
        $excludedFile = Join-Path -Path $markdownFolder -ChildPath "$($_).md"
        if (Test-Path -Path $excludedFile) {
            Remove-Item -Path $excludedFile
        }
    }

    # process remaining files
    $markdownFiles = Get-ChildItem -Path $markdownFolder -Filter *.md

    # update generated markdown file(s) to make them Docusaurus compatible
    ForEach ($markdownFile in $markdownFiles) {
        SetMarkdownLineEndings -MarkdownFile $markdownFile

        $customEditUrl = GetCustomEditUrl -Module $Module -MarkdownFile $markdownFile -EditUrl $EditUrl -Monolithic:$Monolithic

        $frontMatterArgs = @{
            MarkdownFile = $markdownFile
            MetaDescription = $metaDescription
            CustomEditUrl = $customEditUrl
            MetaKeywords = $metaKeywords
            HideTitle = $HideTitle
            HideTableOfContents = $HideTableOfContents
        }
        SetMarkdownFrontMatter @frontmatterArgs

        RemoveMarkdownHeaderOne -MarkdownFile $markdownFile
        ReplaceMarkdownCodeBlocks -MarkdownFile $markdownFile
        SetMarkdownCodeBlockMoniker -MarkdownFile $markdownFile
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
