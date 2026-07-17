[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Scope = "Function")]
param()

function Test-RelatedLinks {
    <#
        .SYNOPSIS
            Dummy module to ensure RELATED LINKS render as clickable links (or plain text).

        .DESCRIPTION
            PlatyPS renders .LINK help entries as markdown list items but generates
            links without clickable text for bare urls and links without a target
            for text entries. Both should be repaired.

        .LINK
            https://example.com/bare-url-should-become-clickable

        .LINK
            Text entries should render as plain text

        .LINK
            about_CommonParameters
    #>
    [CmdletBinding()]
    param()
}
