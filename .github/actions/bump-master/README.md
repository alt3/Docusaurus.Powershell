# Bump Master

Github Action that:

1. replaces module manifest on master repo with bumped module manifest inside the newly built Powershell module (artifact)
2. then creates a commit and pushes it to master using the [no-release] commit message to prevent an endless CI/CD loop
