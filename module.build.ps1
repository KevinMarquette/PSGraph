#requires -Modules InvokeBuild, PSDeploy, BuildHelpers, PSScriptAnalyzer, PlatyPS, Pester
$script:ModuleName = 'PSGraph'

$script:Source = Join-Path $BuildRoot $ModuleName
$script:Output = Join-Path $BuildRoot output
$script:Destination = Join-Path $Output $ModuleName
$script:ModulePath = "$Destination\$ModuleName.psm1"
$script:ManifestPath = "$Destination\$ModuleName.psd1"
$script:Imports = ( 'private', 'public', 'classes' )
$script:TestFile = "$PSScriptRoot\output\TestResults_PS$PSVersion`_$TimeStamp.xml"
$script:HelpRoot = Join-Path $Output 'help'

function TaskX($Name, $Parameters) {task $Name @Parameters -Source $MyInvocation}

Task Default Clean, Build, Pester, UpdateSource, Publish
Task Build CopyToOutput, BuildPSM1, BuildPSD1
Task Pester Build, ImportModule, UnitTests, FullTests
Task Local Build, Pester, UpdateSource

Task Clean {
    
    If (Test-Path $Output)
    {
        $null = Remove-Item $Output -Recurse -ErrorAction Ignore
    }
    $null = New-Item  -Type Directory -Path $Destination -ErrorAction Ignore
}

Task UnitTests {
    $TestResults = Invoke-Pester -Path Tests\*unit* -PassThru -Tag Build -ExcludeTag Slow
    if ($TestResults.FailedCount -gt 0)
    {
        Write-Error "Failed [$($TestResults.FailedCount)] Pester tests"
    }
}

Task FullTests {
    $TestResults = Invoke-Pester -Path Tests -PassThru -OutputFormat NUnitXml -OutputFile $testFile -Tag Build
    if ($TestResults.FailedCount -gt 0)
    {
        Write-Error "Failed [$($TestResults.FailedCount)] Pester tests"
    }
}

Task Specification {

    $TestResults = Invoke-Gherkin $PSScriptRoot\Spec -PassThru
    if ($TestResults.FailedCount -gt 0)
    {
        Write-Error "[$($TestResults.FailedCount)] specification are incomplete"
    }
}

Task CopyToOutput {

    "  Create Directory [$Destination]"
    $null = New-Item -Type Directory -Path $Destination -ErrorAction Ignore

    Get-ChildItem $source -File |
        where name -NotMatch "$ModuleName\.ps[dm]1" |
        Copy-Item -Destination $Destination -Force -PassThru |
        ForEach-Object { "  Create [.{0}]" -f $_.fullname.replace($PSScriptRoot, '')}

    Get-ChildItem $source -Directory |
        where name -NotIn $imports |
        Copy-Item -Destination $Destination -Recurse -Force -PassThru |
        ForEach-Object { "  Create [.{0}]" -f $_.fullname.replace($PSScriptRoot, '')}
}

TaskX BuildPSM1 @{
    Inputs  = (Get-Item "$source\*\*.ps1") 
    Outputs = $ModulePath 
    Jobs    = {
        [System.Text.StringBuilder]$stringbuilder = [System.Text.StringBuilder]::new()    
        foreach ($folder in $imports )
        {
            [void]$stringbuilder.AppendLine( "Write-Verbose 'Importing from [$Source\$folder]'" )
            if (Test-Path "$source\$folder")
            {
                $fileList = Get-ChildItem "$source\$folder\*.ps1" | Where Name -NotLike '*.Tests.ps1'
                foreach ($file in $fileList)
                {
                    $shortName = $file.fullname.replace($PSScriptRoot, '')
                    "  Importing [.$shortName]"
                    [void]$stringbuilder.AppendLine( "# .$shortName" ) 
                    [void]$stringbuilder.AppendLine( [System.IO.File]::ReadAllText($file.fullname) )
                }
            }
        }
        
        "  Creating module [$ModulePath]"
        Set-Content -Path  $ModulePath -Value $stringbuilder.ToString() 
    }
}

TaskX NextPSGalleryVersion @{
    If     = (-Not ( Test-Path "$output\version.xml" ) ) 
    Before = 'BuildPSD1'
    Jobs   = {
        $galleryVersion = Get-NextPSGalleryVersion -Name $ModuleName
        $galleryVersion | Export-Clixml -Path "$output\version.xml"
    }
}

TaskX BuildPSD1 @{
    Inputs  = (Get-ChildItem $Source -Recurse -File) 
    Outputs = $ManifestPath 
    Jobs    = {
    
        Write-Output "  Update [$ManifestPath]"
        Copy-Item "$source\$ModuleName.psd1" -Destination $ManifestPath


        $functions = Get-ChildItem "$ModuleName\Public\*.ps1" | Where-Object { $_.name -notmatch 'Tests'} | Select-Object -ExpandProperty basename      
        Set-ModuleFunctions -Name $ManifestPath -FunctionsToExport $functions

        Write-Output "  Detecting semantic versioning"

        Import-Module ".\$ModuleName"
        $commandList = Get-Command -Module $ModuleName
        Remove-Module $ModuleName

        Write-Output "    Calculating fingerprint"
        $fingerprint = foreach ($command in $commandList )
        {
            foreach ($parameter in $command.parameters.keys)
            {
                '{0}:{1}' -f $command.name, $command.parameters[$parameter].Name
                $command.parameters[$parameter].aliases | Foreach-Object { '{0}:{1}' -f $command.name, $_}
            }
        }
        
        $fingerprint = $fingerprint | Sort-Object

        if (Test-Path .\fingerprint)
        {
            $oldFingerprint = Get-Content .\fingerprint
        }
        
        $bumpVersionType = 'Patch'
        '    Detecting new features'
        $fingerprint | Where {$_ -notin $oldFingerprint } | % {$bumpVersionType = 'Minor'; "      $_"}    
        '    Detecting breaking changes'
        $oldFingerprint | Where {$_ -notin $fingerprint } | % {$bumpVersionType = 'Major'; "      $_"}

        Set-Content -Path .\fingerprint -Value $fingerprint

        # Bump the module version
        $version = [version] (Get-Metadata -Path $manifestPath -PropertyName 'ModuleVersion')

        if ( $version -lt ([version]'1.0.0') )
        {
            # Still in beta, don't bump major version
            if ( $bumpVersionType -eq 'Major'  )
            {
                $bumpVersionType = 'Minor'
            }
            else 
            {
                $bumpVersionType = 'Patch'
            }       
        }

        $galleryVersion = Import-Clixml -Path "$output\version.xml"
        if ( $version -lt $galleryVersion )
        {
            $version = $galleryVersion
        }
        Write-Output "  Stepping [$bumpVersionType] version [$version]"
        $version = [version] (Step-Version $version -Type $bumpVersionType)
        Write-Output "  Using version: $version"
        
        Update-Metadata -Path $ManifestPath -PropertyName ModuleVersion -Value $version
    }
}

Task UpdateSource {
    Copy-Item $ManifestPath -Destination "$source\$ModuleName.psd1"
}

Task ImportModule {
    if ( -Not ( Test-Path $ManifestPath ) )
    {
        "  Modue [$ModuleName] is not built, cannot find [$ManifestPath]"
        Write-Error "Could not find module manifest [$ManifestPath]. You may need to build the module first"
    }
    else
    {
        if (Get-Module $ModuleName)
        {
            "  Unloading Module [$ModuleName] from previous import"
            Remove-Module $ModuleName
        }
        "  Importing Module [$ModuleName] from [$ManifestPath]"
        Import-Module $ManifestPath -Force
    }
}

Task Publish {
    # Gate deployment
    if (
        $ENV:BHBuildSystem -ne 'Unknown' -and
        $ENV:BHBranchName -eq "master" -and
        $ENV:BHCommitMessage -match '!deploy|resolves\s+#\d+'
    )
    {
        $Params = @{
            Path  = $BuildRoot
            Force = $true
        }

        Invoke-PSDeploy @Verbose @Params
    }
    else
    {
        "Skipping deployment: To deploy, ensure that...`n" +
        "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
        "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
        "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage)"
    }
}

TaskX CreateHelp @{
    Partial = $true
    Inputs  = {Get-ChildItem "$ModuleName\Public\*.ps1"}
    Outputs = {
        process
        {
            Get-ChildItem $_ | % {'{0}\{1}.md' -f $HelpRoot, $_.basename}
        }
    }    
    Jobs    = 'ImportModule', {    
        process
        {
            $null = New-Item -Path $HelpRoot -ItemType Directory -ErrorAction SilentlyContinue        
            $mdHelp = @{
                #Module                = $script:ModuleName
                OutputFolder          = $HelpRoot
                AlphabeticParamsOrder = $true
                Verbose               = $true
                Force                 = $true
                Command               = Get-Item $_ | % basename
            }
            New-MarkdownHelp @mdHelp | % fullname
        }    
    }
}

TaskX PackageHelp  @{
    Inputs  = {Get-ChildItem $HelpRoot -Recurse -File}
    Outputs = "$Destination\en-us\$ModuleName-help.xml"
    Jobs    = 'CreateHelp', {
        New-ExternalHelp -Path $HelpRoot -OutputPath "$Destination\en-us" -force | % fullname
    }
}

task Install Uninstall, {
    $version = [version] (Get-Metadata -Path $manifestPath -PropertyName 'ModuleVersion')

    $path = $env:PSModulePath.Split(';').Where( {
            $_ -like 'C:\Users\*'
        }, 'First', 1)

    if ($path -and (Test-Path -Path $path))
    {
        "Using [$path] as base path..."
        $path = Join-Path -Path $path -ChildPath $ModuleName
        $path = Join-Path -Path $path -ChildPath $version

        "Creating directory at [$path]..."
        New-Item -Path $path -ItemType 'Directory' -Force -ErrorAction 'Ignore'

        "Copying items from [$Destination] to [$path]..."
        Copy-Item -Path "$Destination\*" -Destination $path -Recurse -Force
    }
}

task Uninstall {
    'Unloading Modules...'
    Get-Module -Name $ModuleName -ErrorAction 'Ignore' | Remove-Module

    'Uninstalling Module packages...'
    $modules = Get-Module $ModuleName -ErrorAction 'Ignore' -ListAvailable
    foreach ($module in $modules)
    {
        Uninstall-Module -Name $module.Name -RequiredVersion $module.Version -ErrorAction 'Ignore'
    }

    'Cleaning up manually installed Modules...'
    $path = $env:PSModulePath.Split(';').Where( {
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
