
task Install Uninstall, {
    $version = [version] (Get-Metadata -Path $manifestPath -PropertyName 'ModuleVersion')

    $path = $env:PSModulePath.Split(';').Where({
        $_ -like 'C:\Users\*'
    }, 'First', 1)

    if ($path -and (Test-Path -Path $path))
    {
        "Using [$path] as base path..."
        $path = Join-Path -Path $path -ChildPath $ModuleName
        $path = Join-Path -Path $path -ChildPath $version

        "Creating directory at [$path]..."
        New-Item -Path $path -ItemType 'Directory' -Force -ErrorAction 'Ignore'

        "Copying items from [$Destination] to [$path]..."
        Copy-Item -Path "$Destination\*" -Destination $path -Recurse -Force
    }
}
