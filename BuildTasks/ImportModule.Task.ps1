function ImportModule
{
    param(
        [string]$path,
        [switch]$PassThru
    )


    if (-not(Test-Path -Path $path))
    {
        "Cannot find [$path]."
        Write-Error -Message "Could not find module manifest [$path]"
    }
    else
    {
        $file = Get-Item $path
        $name = $file.BaseName

        $loaded = Get-Module -Name $name -All -ErrorAction Ignore
        if ($loaded)
        {
            "Unloading Module [$name] from a previous import..."
            $loaded | Remove-Module -Force
        }

        "Importing Module [$name] from [$($file.fullname)]..."
        Import-Module -Name $file.fullname -Force -PassThru:$PassThru
    }
}

task ImportModule {
    ImportModule -Path $ManifestPath
}
