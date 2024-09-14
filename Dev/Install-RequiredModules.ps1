<#
    .LINK
    https://github.com/JustinGrote/ModuleFast?tab=readme-ov-file#load-modulefast-as-a-module-for-the-session
#>
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'Required for ModuleFast installation')]
param()

Invoke-WebRequest bit.ly/modulefast | Invoke-Expression

Install-ModuleFast -Path .\Dev\RequiredModules.psd1 -Verbose
