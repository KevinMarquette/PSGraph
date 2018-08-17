Write-Verbose "Initializing build variables"

$Script:DocsPath = Join-Path -Path $BuildRoot -ChildPath 'Docs'
Write-Verbose "  DocsPath [$DocsPath]"

$Script:Output = Join-Path -Path $BuildRoot -ChildPath 'Output'
Write-Verbose "  Output [$Output]"

$Script:Source = Join-Path -Path $BuildRoot -ChildPath $ModuleName
Write-Verbose "  Source [$Source]"

$Script:Destination = Join-Path -Path $Output -ChildPath $ModuleName
Write-Verbose "  Destination [$Destination]"

$Script:ManifestPath = Join-Path -Path $Destination -ChildPath "$ModuleName.psd1"
Write-Verbose "  ManifestPath [$ManifestPath]"

$Script:ModulePath = Join-Path -Path $Destination -ChildPath "$ModuleName.psm1"
Write-Verbose "  ModulePath [$ModulePath]"

$Script:Folders = 'Classes', 'Includes', 'Internal', 'Private', 'Public', 'Resources'
Write-Verbose "  Folders [$Folders]"

$Script:TestFile = "$BuildRoot\Output\TestResults_PS$PSVersion`_$TimeStamp.xml"
Write-Verbose "  TestFile [$TestFile]"

$Script:PSRepository = 'PSGallery'
Write-Verbose "  PSRepository [$TestFile]"

function taskx($Name, $Parameters) { task $Name @Parameters -Source $MyInvocation }
