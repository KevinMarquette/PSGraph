
task Uninstall {
    'Unloading Modules...'
    Get-Module -Name $ModuleName -ErrorAction 'Ignore' | Remove-Module -Force

    'Uninstalling Module packages...'
    $modules = Get-Module $ModuleName -ErrorAction 'Ignore' -ListAvailable
    foreach ($module in $modules)
    {
        Uninstall-Module -Name $module.Name -RequiredVersion $module.Version -ErrorAction 'Ignore'
    }

    'Cleaning up manually installed Modules...'
    $path = $env:PSModulePath.Split(';').Where({
        $_ -like 'C:\Users\*'
    }, 'First', 1)

    $path = Join-Path -Path $path -ChildPath $ModuleName
    if ($path -and (Test-Path -Path $path))
    {
        'Removing files... (This may fail if any DLLs are in use.)'
        Get-ChildItem -Path $path -File -Recurse |
            Remove-Item -Force | ForEach-Object 'FullName'

        'Removing folders... (This may fail if any DLLs are in use.)'
        Remove-Item $path -Recurse -Force
    }
}
