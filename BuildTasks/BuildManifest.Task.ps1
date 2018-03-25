
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

        'Detecting semantic versioning...'
        "Importing Module [$ManifestPath]..."
        Import-Module -FullyQualifiedName $ManifestPath

        "Get-Command -Module [$ModuleName]..."
        $commands = Get-Command -Module $ModuleName

        "Removing Module [$ModuleName]..."
        Remove-Module -Name $ModuleName -Force

        'Calculating fingerprint...'
        $fingerprint = foreach ($command in $commands)
        {
            foreach ($parameter in $command.Parameters.Keys)
            {
                '{0}:{1}' -f $command.Name, $command.Parameters[$parameter].Name
                foreach ($alias in $command.Parameters[$parameter].Aliases)
                {
                    '{0}:{1}' -f $command.Name, $alias
                }
            }
        }

        $fingerprint = $fingerprint | Sort-Object

        if (Test-Path -Path '.\fingerprint')
        {
            $oldFingerprint = Get-Content -Path '.\fingerprint'
        }

        $bumpVersionType = 'Patch'

        'Detecting new features...'
        $features = $fingerprint |
            Where-Object { $_ -notin $oldFingerprint }

        foreach ($feature in $features)
        {
            $feature
            $bumpVersionType = 'Minor'
        }

        'Detecting breaking changes...'
        $breakingChanges = $oldFingerprint |
            Where-Object { $_ -notin $fingerprint }

        foreach ($breakingChange in $breakingChanges)
        {
            $breakingChange
            $bumpVersionType = 'Major'
        }

        Set-Content -Path '.\fingerprint' -Value $fingerprint

        # Bump the module version
        $version = [version] (Get-Metadata -Path $manifestPath -PropertyName 'ModuleVersion')

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

        "Stepping [$bumpVersionType] version [$version]..."
        $version = [version] (Step-Version -Version $version -Type $bumpVersionType)

        $build = 0
        if ($null -ne $env:Build_BuildID)
        {
            $build = $env:Build_BuildID
        }

        $version = [version]::new($version.Major, $version.Minor, $version.Build, $build)
        "Using version [$version]..."
        "##vso[build.updatebuildnumber]$version"

        Update-Metadata -Path $ManifestPath -PropertyName 'ModuleVersion' -Value $version
    }
}
