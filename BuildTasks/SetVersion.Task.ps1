funciton GetModulePublicInterfaceMap
{
    param($Path)
    $module = ImportModule -Path $Path -PassThru
    $exportedCommands = @(
        $module.ExportedFunctions.values
        $module.ExportedCmdlets.values
        $module.ExportedAliases.values
    )

    $data = foreach($command in $exportedCommands)
    {
        foreach ($parameter in $command.Parameters.Keys)
        {
            if($false -eq $command.Parameters[$parameter].IsDynamic)
            {
                '{0}:{1}' -f $command.Name, $command.Parameters[$parameter].Name
                foreach ($alias in $command.Parameters[$parameter].Aliases)
                {
                    '{0}:{1}' -f $command.Name, $alias
                }
            }
        }
    }
    [System.Collections.Generic.HashSet[string]]$data
}

task SetVersion
{
    $publishedModule = Find-Module -Name $ModuleName |
        Sort-Object -Property {[version]$_.Version} -Descending |
        Select -First 1

    [version] $publishedVersion = $publishedModule.Version
    [version] $sourceVersion =  (Get-Metadata -Path $manifestPath -PropertyName 'ModuleVersion')

    if($sourceVersion -gt $publishedVersion)
    {
        Write-Verbose "Using existing version as base [$sourceVersion]"
        $version = $sourceVersion
    }
    else
    {
        "Downloading published module to check for breaking changes"
        $downloadFolder = Join-Path -Path $output downloads
        $null = New-Item -ItemType Directory -Path $downloadFolder -Force -ErrorAction Ignore
        $publishedModule | Save-Module -Path $downloadFolder

        $publishedInterface = GetModulePublicInterfaceMap -Path (Join-Path $downloadFolder $ModuleName)
        $buildInterface = GetModulePublicInterfaceMap -Path $ManifestPath

        $bumpVersionType = 'Patch'
        if($publishedInterface.IsSubsetOf($buildInterface))
        {
            $bumpVersionType = 'Major'
        }
        elseif ($publishedInterface.count -ne $buildInterface.count)
        {
            $bumpVersionType = 'Minor'
        }

        if ($version -lt ([version] '1.0.0'))
        {
            "Module is still in beta; don't bump major version."
            if ($bumpVersionType -eq 'Major')
            {
                $bumpVersionType = 'Minor'
            }
            else
            {
                $bumpVersionType = 'Patch'
            }
        }

        $version = [version] (Step-Version -Version $version -Type $bumpVersionType)
    }

    $build = -1
    if ($null -ne $env:Build_BuildID)
    {
        $build = $env:Build_BuildID
    }

    $version = [version]::new($version.Major, $version.Minor, $version.Build, $build)
    "Using version [$version]"
    Update-Metadata -Path $ManifestPath -PropertyName 'ModuleVersion' -Value $version

    if(Test-Path $BuildRoot\fingerprint)
    {
        Remove-Item $BuildRoot\fingerprint
    }
}
