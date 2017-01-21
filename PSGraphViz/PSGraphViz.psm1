Write-Verbose "Importing Functions"

# Import everything in sub folders folder
foreach($folder in @('private', 'public', 'classes'))
{
    $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
    if(Test-Path -Path $root)
    {
        $files = Get-ChildItem -Path $root -Filter *.ps1 -Exclude *.tests.ps1

        # dot source each file
        $files | ForEach-Object{Write-Verbose $_.name; . $_.FullName}
    }
}

Export-Modulemember -function (Get-ChildItem -Path "$PSScriptRoot\public\*.ps1").basename
