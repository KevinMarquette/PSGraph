$Script:DocsPath = Join-Path -Path $BuildRoot -ChildPath 'Docs'
$Script:Output = Join-Path -Path $BuildRoot -ChildPath 'Output'
$Script:Source = Join-Path -Path $BuildRoot -ChildPath $ModuleName
$Script:Destination = Join-Path -Path $Output -ChildPath $ModuleName
$Script:ManifestPath = Join-Path -Path $Destination -ChildPath "$ModuleName.psd1"
$Script:ModulePath = Join-Path -Path $Destination -ChildPath "$ModuleName.psm1"
$Script:Folders = 'Classes', 'Includes', 'Internal', 'Private', 'Public', 'Resources'
$Script:TestFile = "$BuildRoot\Output\TestResults_PS$PSVersion`_$TimeStamp.xml"
function taskx($Name, $Parameters) { task $Name @Parameters -Source $MyInvocation }
