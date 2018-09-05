Write-Verbose "Initializing build variables" -Verbose
Write-Verbose "  Existing BuildRoot [$BuildRoot]" -Verbose

$Script:DocsPath = Join-Path -Path $BuildRoot -ChildPath 'Docs'
Write-Verbose "  DocsPath [$DocsPath]" -Verbose

$Script:Output = Join-Path -Path $BuildRoot -ChildPath 'Output'
Write-Verbose "  Output [$Output]" -Verbose

$Script:Source = Join-Path -Path $BuildRoot -ChildPath $ModuleName
Write-Verbose "  Source [$Source]" -Verbose

$Script:Destination = Join-Path -Path $Output -ChildPath $ModuleName
Write-Verbose "  Destination [$Destination]" -Verbose

$Script:ManifestPath = Join-Path -Path $Destination -ChildPath "$ModuleName.psd1"
Write-Verbose "  ManifestPath [$ManifestPath]" -Verbose

$Script:ModulePath = Join-Path -Path $Destination -ChildPath "$ModuleName.psm1"
Write-Verbose "  ModulePath [$ModulePath]" -Verbose

$Script:Folders = 'Classes', 'Includes', 'Internal', 'Private', 'Public', 'Resources'
Write-Verbose "  Folders [$Folders]" -Verbose

$Script:TestFile = "$BuildRoot\Output\TestResults_PS$PSVersion`_$TimeStamp.xml"
Write-Verbose "  TestFile [$TestFile]" -Verbose

$Script:PSRepository = 'PSGallery'
Write-Verbose "  PSRepository [$TestFile]" -Verbose

function taskx($Name, $Parameters) { task $Name @Parameters -Source $MyInvocation }
