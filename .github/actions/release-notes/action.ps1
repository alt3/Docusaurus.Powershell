<#
    .SYNOPSIS
    Generates a changelog in markdown format.

    .NOTES
    Expects a git clone of master branch with full history in subfolder `_master`.
#>

Write-Output "Generating CHANGELOG:"

Set-Location _master

$latestTagVersion = git describe --tags --abbrev=0
Write-Output "Previous Tag Version = $latestTagVersion"

$latestTagHash = git show-ref -s $latestTagVersion
Write-Output "Previous Tag Hash    = $latestTagHash"

[string]$markdownChangeLog = "## CHANGELOG`n"

$logLines = git log "$($latestTagHash)...HEAD" --pretty=format:"%H%x09%h%x09%an%x09%s" --date=short
$logLines | ForEach-Object {
    ($hash, $shortHash, $author, $message) = $_.Split("`t")

    # exclude commit messages matching this regex
    if ($message -match '^bump manifest|^merge\s') {
        Write-Output "=> excluding commit message '$message'"
        return
    }

    $hashLink = "[$shortHash]($env:GITHUB_REPO_URL/commit/$hash)"
    $authorLink = "[$author](https://github.com/$author)"

    $markdownChangeLog += "`n- $message ($authorLink in $hashLink)"
}

## Log generated markdown
Write-Output "Generated markdown:"
$markdownChangeLog

# create UTF-8 file
$filePath = Join-Path -Path (get-item ((get-location).Path)).Parent.FullName -ChildPath "CHANGELOG.md"
Write-Output "Creating markdown file $filePath"

[System.IO.File]::WriteAllLines($filePath, [string[]]$markdownChangeLog)
