<#
    .SYNOPSIS
    Generates a changelog in markdown format.
#>

Write-Output "Generating CHANGELOG:"
$latestTagVersion = git describe --tags --abbrev=0
$latestTagHash = git show-ref -s $latestTagVersion
Write-Output "Previous Tag Version = $latestTagVersion"
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

# create UTF-8 file
$filename = "CHANGELOG.md"

[IO.File]::AppendAllLines($filename, [string[]]$markdownChangeLog)
