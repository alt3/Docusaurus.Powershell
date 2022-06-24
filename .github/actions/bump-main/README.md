# Bump Main

Github Action that:

1. replaces module manifest on main repo with bumped module manifest inside the newly built PowerShell module (artifact)
2. then creates a commit and pushes it to main using the [no-release] commit message to prevent an endless CI/CD loop
