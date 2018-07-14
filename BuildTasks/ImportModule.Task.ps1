
task ImportModule {
    if (-not(Test-Path -Path $ManifestPath))
    {
        "Module [$ModuleName] is not built; cannot find [$ManifestPath]."
        Write-Error -Message "Could not find module manifest [$ManifestPath]. You may need to build the module first."
    }
    else
    {
        $loaded = Get-Module -Name $ModuleName -All
        if ($loaded)
        {
            "Unloading Module [$ModuleName] from a previous import..."
            $loaded | Remove-Module -Force
        }

        "Importing Module [$ModuleName] from [$ManifestPath]..."
        Import-Module -FullyQualifiedName $ManifestPath -Force
    }
}
