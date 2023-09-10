[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Scope = "Function")]
param()

function Test-SeparateMarkdownHeadings {
    <#
        .SYNOPSIS
            Dummy module to test PowerShell 7 NATIVE multi-line code examples

        .EXAMPLE
            $shouldInsertBlankLine

            # MUST MATCH: HEADER1 WITH SINGLE LINE CONTENT
            Some h1 text

        .EXAMPLE
            $shouldInsertBlankLine

            # MUST MATCH: VALID HEADER1 WITH MULTILINE CONTENT
            Allows you to execute parts of a test script within the
            scope of a PowerShell script module.

        .EXAMPLE
            $shouldInsertBlankLine

            ## MUST MATCH: VALID HEADING 2
            But only if there is content beneath it

        .EXAMPLE
            $shouldInsertBlankLine

            ### MUST MATCH: VALID HEADING 3
            But only if there is content beneath it

        .EXAMPLE
            $shouldInsertBlankLine

            #### MUST MATCH: VALID HEADING 4
            But only if there is content beneath it

        .EXAMPLE
            $shouldInsertBlankLine

            ##### MUST MATCH: VALID HEADING 5
            But only if there is content beneath it

        .EXAMPLE
            $shouldInsertBlankLine

            ###### MUST MATCH: HEADING 6
            But only if there is content beneath it

        .EXAMPLE
            $shouldNotInsertBlankLine

            ####### SHOULD NOT MATCH: BECAUSE MARKDOWN HEADING 7 DOES NOT EXIST
            Even if there is content beneath it

        .EXAMPLE
            $shouldNotInsertBlankLine

            ###### SHOULD NOT MATCH: NO CONTENT BENEATH IT

        .EXAMPLE
            $shouldNotInsertBlankLine

            ```powershell
                # bug: this should not match as a header
            ```

        .EXAMPLE
            $shouldNotInsertBlankLine

            ```powershell
            # Bug: this should not match as a header
            function PublicFunction
            {
                # Does something
            }

        .EXAMPLE
            $shouldNotInsertBlankLine

            Bug: This should not match as a header
            When used together with Throw, throwing an exception is preferred.
            Default value: $false

        .EXAMPLE
            $shouldNotInsertBlankLine

            Bug: this should not match as a header
            required parameter-values.
            This is useful in when tests are generated dynamically
            based on parameter-input.
            This method enables complex test-solutions while being
            able to re-use a lot of test-code.

            ######################################
            ## This ASCII art should not match as a header
            ######################################
            But here we go
    #>
    }
