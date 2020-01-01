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
            $parameters = @{
                Module = "Alt3.Docusaurus.Powershell"
                DocsFolder = "D:\my-project\docs"
                Sidebar = "commands"
                Exclude = @(
                    "Get-SomeCommand"
                )
                MetaDescription = 'Help page for the Powershell command "%1"'
                MetaKeywords = @(
                    "Powershell"
                    "Documentation"
                )
            }

            New-DocusaurusHelp @parameters
            ```

            This example uses
            [splatting](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting)
            to override default settings.

            See the list of Parameters below for all available overrides.

        .PARAMETER Module
            Specifies the module this cmdlet will generate Docusaurus documentation for.

            You may specify a module name, a `.psd1` file or a `.psm1` file.

        .PARAMETER DocsFolder
            Specifies the absolute or relative **path** to the Docusaurus `docs` folder.

            Optional, defaults to `docusaurus/docs`, case sensitive.

        .PARAMETER Sidebar
            Specifies the **name** of the docs subfolder in which the `.mdx` files will be created.

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

        .PARAMETER KeepHeader1
            By default, the `H1` element will be removed from the PlatyPS generated markdown because
            Docusaurus uses the per-page frontmatter variable `title` as the page's H1 element instead.

            You may use this switch parameter to keep the markdown `H1` element, most likely in
            combination with the `HideTitle` parameter.

        .PARAMETER HideTitle
            Sets the Docusaurus front matter variable `hide_title`.

            Optional, defaults to `false`.

        .PARAMETER HideTableOfContents
            Sets the Docusaurus front matter variable `hide_table_of_contents`.

            Optional, defaults to `false`.

        .PARAMETER NoPlaceholderExamples
            By default, Docusaurus will generate a placeholder example if your Get-Help
            definition does not contain any `EXAMPLE` nodes.

            You can use this switch to disable that behavior which will result in an empty `EXAMPLES` section.

        .PARAMETER Monolithic
            Use this optional parameter if the Powershell module source is monolithic.

            Will point all `custom_edit_url` front matter variables to the `.psm1` file.

        .PARAMETER VendorAgnostic
            Use this switch parameter if you **do not want to use Docusaurus** but would still like
            to benefit of the markdown-enrichment functions this module provides.

            If used, the `New-GetDocusaurusHelp` command will produce the exact same markdown as
            always but will skip the following two Docusaurus-specific steps:

            - PlatyPS frontmatter will not be touched
            - `docusaurus.sidebar.js` file will not be generated

            For more information please
            [visit this page](https://docusaurus-powershell.netlify.com/docs/faq/vendor-agnostic).

        .NOTES
            Please note that Docusaurus v2 is an early and alpha version, just like this module.

        .LINK
            https://docusaurus-powershell.netlify.com/

        .LINK
            https://v2.docusaurus.io/

        .LINK
            https://github.com/PowerShell/platyPS
    #>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True)][string]$Module,
        [Parameter(Mandatory = $False)][string]$DocsFolder = "docusaurus/docs",
        [Parameter(Mandatory = $False)][string]$Sidebar = "commands",
        [Parameter(Mandatory = $False)][array]$Exclude = @(),
        [Parameter(Mandatory = $False)][string]$EditUrl,
        [Parameter(Mandatory = $False)][string]$MetaDescription,
        [Parameter(Mandatory = $False)][array]$MetaKeywords = @(),
        [switch]$KeepHeader1,
        [switch]$HideTitle,
        [switch]$HideTableOfContents,
        [switch]$NoPlaceHolderExamples,
        [switch]$Monolithic,
        [switch]$VendorAgnostic
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

    $moduleName = [io.path]::GetFileName($module)

    # markdown for the module will be copied into the sidebar subfolder
    Write-Verbose "Initializing sidebar folder:"
    $sidebarFolder = Join-Path -Path $DocsFolder -ChildPath $Sidebar
    CreateOrCleanFolder -Path $sidebarFolder

    # create tempfolder used for generating the PlatyPS files and creating the mdx files
    $tempFolder = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "Alt3.Docusaurus.Powershell" | Join-Path -ChildPath $moduleName
    InitializeTempFolder -Path $tempFolder

    # generate PlatyPs markdown files
    Write-Verbose "Generating PlatyPS files."
    New-MarkdownHelp -Module $Module -OutputFolder $tempFolder -Force | Out-Null

    # remove files matching excluded commands
    Write-Verbose "Removing excluded files:"
    $Exclude | ForEach-Object {
        RemoveFile -Path (Join-Path -Path $tempFolder -ChildPath "$($_).md")
    }

    # rename PlatyPS files and create an `.mdx` copy we will transform
    Write-Verbose "Cloning PlatyPS files."
    Get-ChildItem -Path $tempFolder -Filter *.md | ForEach-Object {
        $platyPsFile = $_.FullName -replace '.md', '.PlatyPS.md'
        $mdxFile = $_.FullName -replace '.md', '.mdx'
        Move-Item -Path $_.FullName -Destination $platyPsFile
        Copy-Item  -Path $platyPsFile -Destination $mdxFile
    }

    # update all remaining mdx files to make them Docusaurus compatible
    Write-Verbose "Updating mdx files."
    $mdxFiles = Get-ChildItem -Path $tempFolder -Filter *.mdx

    ForEach ($mdxFile in $mdxFiles) {
        Write-Verbose "Processing $($mdxFile.Name):"

        # prepare per-page variables
        $customEditUrl = GetCustomEditUrl -Module $Module -MarkdownFile $mdxFile -EditUrl $EditUrl -Monolithic:$Monolithic

        $frontMatterArgs = @{
            MarkdownFile = $mdxFile
            MetaDescription = $metaDescription
            CustomEditUrl = $customEditUrl
            MetaKeywords = $metaKeywords
            HideTitle = $HideTitle
            HideTableOfContents = $HideTableOfContents
        }

        # transform the markdown using these steps (overwriting the mdx file per step)
        SetLfLineEndings -MarkdownFile $mdxFile

        if (-not($VendorAgnostic)) {
            ReplaceFrontMatter @frontmatterArgs
        }

        ReplaceHeader1 -MarkdownFile $mdxFile -KeepHeader1:$KeepHeader1
        ReplaceExamples -MarkdownFile $mdxFile -NoPlaceholderExamples:$NoPlaceholderExamples
        InsertPowershellMonikers -MarkdownFile $mdxFile
        UnescapeSpecialChars -MarkdownFile $mdxFile
        SeparateHeaders -MarkdownFile $mdxFile
        InsertFinalNewline -MarkdownFile $mdxFile
    }

    # copy updated mdx files to the target folder
    Write-Verbose "Copying mdx files to sidebar folder."
    Get-ChildItem -Path $tempFolder -Filter *.mdx | ForEach-Object {
        Copy-Item  -Path $_.FullName -Destination (Join-Path -Path $sidebarFolder -ChildPath ($_.Name))
    }

    # generate the `.js` file used for the docusaurus sidebar
    if (-not($VendorAgnostic)) {
        NewSidebarIncludeFile -MarkdownFiles $mdxFiles -TempFolder $tempFolder -OutputFolder $sidebarFolder -Sidebar $Sidebar
    }

    # output Get-ChildItem so end-user can post-process generated files as they see fit
    Get-ChildItem -Path $sidebarFolder
}
