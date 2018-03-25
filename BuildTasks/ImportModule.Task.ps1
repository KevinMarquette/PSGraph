
task ImportModule {
    if (-not(Test-Path -Path $ManifestPath))
    {
        "Module [$ModuleName] is not built; cannot find [$ManifestPath]."
        Write-Error -Message "Could not find module manifest [$ManifestPath]. You may need to build the module first."
    }
    else
    {
        if (Get-Module -Name $ModuleName)
        {
            "Unloading Module [$ModuleName] from a previous import..."
            Remove-Module -Name $ModuleName
        }

        "Importing Module [$ModuleName] from [$ManifestPath]..."
        Import-Module -FullyQualifiedName $ManifestPath -Force
    }
}
