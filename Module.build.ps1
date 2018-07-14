$Script:ModuleName = Split-Path -Leaf $PSScriptRoot
$Script:CodeCoveragePercent = 0.0 # 0 to 1
. $psscriptroot\BuildTasks\InvokeBuildInit.ps1

task Default Build, Test, UpdateSource
task Build Copy, BuildModule, BuildManifest, Helpify
task Helpify GenerateMarkdown, GenerateHelp
task Test Build, ImportModule, FullTests

Write-Host 'Import common tasks'
Get-ChildItem -Path $buildroot\BuildTasks\*.Task.ps1 |
    ForEach-Object {Write-Host $_.FullName;. $_.FullName}
