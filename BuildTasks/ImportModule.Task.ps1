funciton ImportModule
{
    param(
        [string]$path,
        [switch]$PassThru
    )

    $file = Get-ChildItem $path
    $name = $file.BaseName

    if (-not(Test-Path -Path $path))
    {
        "Cannot find [$($path.fullname)]."
        Write-Error -Message "Could not find module manifest [$($path.fullname)]"
    }
    else
    {
        $loaded = Get-Module -Name $name -All -ErrorAction Ignore
        if ($loaded)
        {
            "Unloading Module [$name] from a previous import..."
            $loaded | Remove-Module -Force
        }

        "Importing Module [$name] from [$($path.fullname)]..."
        Import-Module -FullyQualifiedName $path.fullname -Force -PassThru:$PassThru
    }
}

task ImportModule {
    ImportModule -Path $ManifestPath
}
