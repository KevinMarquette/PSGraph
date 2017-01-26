Write-Verbose "Importing Functions"

# Import everything in sub folders folder
foreach($folder in @('private', 'public', 'classes'))
{
    
    $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
    if(Test-Path -Path $root)
    {
        Write-Verbose "processing folder $root"
        $files = Get-ChildItem -Path $root -Filter *.ps1

        # dot source each file
        $files | where-Object{ $_.name -NotLike '*.Tests.ps1'} | 
            ForEach-Object{Write-Verbose $_.name; . $_.FullName}
    }
}

Export-ModuleMember -function (Get-ChildItem -Path "$PSScriptRoot\public\*.ps1").basename

# Hack for my build system that had a conflit with the keyword node
New-Alias -Name 'DiGraph' -Value 'Graph' -ErrorAction SilentlyContinue
Export-ModuleMember -Alias 'DiGraph'
