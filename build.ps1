<#
.Description
Installs and loads all the required modules for the build.
Derived from scripts written by Warren F. (RamblingCookieMonster)
#>

[cmdletbinding()]
param ($Task = 'Default')
"Starting build"

# Grab nuget bits, install modules, set build variables, start build.
"  Install Dependent Modules"
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
Install-Module InvokeBuild, PSDeploy, BuildHelpers, PSScriptAnalyzer, PlatyPS -force -Scope CurrentUser
Install-Module Pester -Force -SkipPublisherCheck -Scope CurrentUser

"  Import Dependent Modules"
Import-Module InvokeBuild, BuildHelpers, PSScriptAnalyzer

Set-BuildEnvironment

"  InvokeBuild"
Invoke-Build $Task -Result result
if ($Result.Error)
{
    exit 1
}
else
{
    exit 0
}