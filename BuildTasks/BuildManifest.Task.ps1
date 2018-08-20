
taskx BuildManifest @{
    Inputs  = (Get-ChildItem -Path $Source -Recurse -File)
    Outputs = $ManifestPath
    Jobs    = {
        "Updating [$ManifestPath]..."
        Copy-Item -Path "$Source\$ModuleName.psd1" -Destination $ManifestPath

        $functions = Get-ChildItem -Path "$ModuleName\Public\*.ps1" -ErrorAction 'Ignore' |
            Where-Object 'Name' -notmatch 'Tests'

        if ($functions)
        {
            'Setting FunctionsToExport...'
            Set-ModuleFunctions -Name $ManifestPath -FunctionsToExport $functions.BaseName
        }
    }
}
