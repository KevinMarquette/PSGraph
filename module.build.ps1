
$script:ModuleName = 'PSGraph'
$script:Source = Join-Path $PSScriptRoot $ModuleName
$script:Output = Join-Path $PSScriptRoot output
$script:Destination = Join-Path $Output $ModuleName
$script:ModulePath = "$Destination\$ModuleName.psm1"
$script:ManifestPath = "$Destination\$ModuleName.psd1"
$script:Imports = ( 'private', 'public', 'classes' )
$script:TestFile = "$PSScriptRoot\output\TestResults_PS$PSVersion`_$TimeStamp.xml"

Task Default Build, Pester, UpdateSource, Publish
Task Build CopyToOutput, BuildPSM1, BuildPSD1
Task Pester Build, ImportModule, UnitTests, FullTests

Task Clean {
    $null = Remove-Item $Output -Recurse -ErrorAction Ignore
    $null = New-Item  -Type Directory -Path $Destination
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

    Write-Output "  Create Directory [$Destination]"
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

Task BuildPSM1 -Inputs (Get-Item "$source\*\*.ps1") -Outputs $ModulePath {

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
                Write-Output "  Importing [.$shortName]"
                [void]$stringbuilder.AppendLine( "# .$shortName" ) 
                [void]$stringbuilder.AppendLine( [System.IO.File]::ReadAllText($file.fullname) )
            }
        }
    }
    
    Write-Output "  Creating module [$ModulePath]"
    Set-Content -Path  $ModulePath -Value $stringbuilder.ToString() 
}

Task NextPSGalleryVersion -if (-Not ( Test-Path "$output\version.xml" ) ) -Before BuildPSD1 {
    $galleryVersion = Get-NextPSGalleryVersion -Name $ModuleName
    $galleryVersion | Export-Clixml -Path "$output\version.xml"
}

Task BuildPSD1 -inputs (Get-ChildItem $Source -Recurse -File) -Outputs $ManifestPath {
   
    Write-Output "  Update [$ManifestPath]"
    Copy-Item "$source\$ModuleName.psd1" -Destination $ManifestPath

    $bumpVersionType = 'Patch'

    $functions = Get-ChildItem "$ModuleName\Public\*.ps1" | Where-Object { $_.name -notmatch 'Tests'} | Select-Object -ExpandProperty basename      

    $oldFunctions = (Get-Metadata -Path $manifestPath -PropertyName 'FunctionsToExport')

    $functions | Where {$_ -notin $oldFunctions } | % {$bumpVersionType = 'Minor'}
    $oldFunctions | Where {$_ -notin $Functions } | % {$bumpVersionType = 'Major'}

    Set-ModuleFunctions -Name $ManifestPath -FunctionsToExport $functions

    # Bump the module version
    $version = [version] (Get-Metadata -Path $manifestPath -PropertyName 'ModuleVersion')
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

Task UpdateSource {
    Copy-Item $ManifestPath -Destination "$source\$ModuleName.psd1"
}

Task ImportModule {
    if ( -Not ( Test-Path $ManifestPath ) )
    {
        Write-Output "  Modue [$ModuleName] is not built, cannot find [$ManifestPath]"
        Write-Error "Could not find module manifest [$ManifestPath]. You may need to build the module first"
    }
    else
    {
        if (Get-Module $ModuleName)
        {
            Write-Output "  Unloading Module [$ModuleName] from previous import"
            Remove-Module $ModuleName
        }
        Write-Output "  Importing Module [$ModuleName] from [$ManifestPath]"
        Import-Module $ManifestPath -Force
    }
}

Task Publish {
    # Gate deployment
    if (
        $ENV:BHBuildSystem -ne 'Unknown' -and 
        $ENV:BHBranchName -eq "master" -and 
        $ENV:BHCommitMessage -match '!deploy'
    )
    {
        $Params = @{
            Path  = $ModulePath
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