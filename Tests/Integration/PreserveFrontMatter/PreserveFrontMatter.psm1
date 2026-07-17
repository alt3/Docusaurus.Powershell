[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Scope = "Function")]
param()

function Test-PreserveFrontMatter {
    <#
        .SYNOPSIS
            Dummy module to ensure user-enriched front matter keys are preserved (https://github.com/alt3/Docusaurus.Powershell/issues/185).

        .DESCRIPTION
            Users can enrich the front matter by adding keys to `CommandHelp.Metadata`
            before passing the objects to `New-DocusaurusHelp -CommandHelp`, so:

            - user-added keys (like `description`) must survive the front matter replacement
            - preserved keys must win over generated values (`-MetaDescription` must not
              overwrite an existing `description` key)
            - the PlatyPS-native keys must still be replaced with the Docusaurus variables
    #>
    [CmdletBinding()]
    param()
}
