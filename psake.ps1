# PSake makes variables declared here available in other scriptblocks
# Init some things
Properties {
    # Find the build folder based on build system
        $ProjectRoot = $ENV:BHProjectPath
        if(-not $ProjectRoot)
        {
            $ProjectRoot = $PSScriptRoot
        }

    $Timestamp = Get-date -uformat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"
    $lines = '----------------------------------------------------------------------'

    $Verbose = @{}
    if($ENV:BHCommitMessage -match "!verbose")
    {
        $Verbose = @{Verbose = $True}
    }
}

Task Default -Depends Deploy

Task Init {
    $lines
    Set-Location $ProjectRoot
    "Build System Details:"
    Get-Item ENV:BH* | Format-List
    "`n"
    "Check for node conflict"
    Get-Command node | Select-Object *
}

Task Test -Depends Init  {
    $lines
    "`n`tSTATUS: Testing with PowerShell $PSVersion"

    # Gather test results. Store them in a variable and file
    $TestResults = Invoke-Pester -Path $ProjectRoot\Tests -PassThru -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile" -Tag Build

    # In Appveyor?  Upload our tests! #Abstract this into a function?
    If($ENV:BHBuildSystem -eq 'AppVeyor')
    {
        "Uploading $ProjectRoot\$TestFile to AppVeyor"
        "JobID: $env:APPVEYOR_JOB_ID"
        (New-Object 'System.Net.WebClient').UploadFile(
            "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)",
            (Resolve-Path "$ProjectRoot\$TestFile" )
        )
    }

    Remove-Item "$ProjectRoot\$TestFile" -Force -ErrorAction SilentlyContinue

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if($TestResults.FailedCount -gt 0)
    {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
    "`n"
}

Task Build -Depends Test {
    $lines

    $functions = Get-ChildItem "$PSScriptRoot\$env:BHProjectName\Public\*.ps1" | 
            Where-Object{ $_.name -notmatch 'Tests'} |
            Select-Object -ExpandProperty basename      

    # Load the module, read the exported functions, update the psd1 FunctionsToExport
    Set-ModuleFunctions -Name $env:BHPSModuleManifest -FunctionsToExport $functions

    # Bump the module version
    $Version = Get-NextPSGalleryVersion -Name $env:BHProjectName
    Update-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -Value $Version
}

Task Deploy -Depends Build {
    $lines

    # Gate deployment
    if(
        $ENV:BHBuildSystem -ne 'Unknown' -and
        $ENV:BHBranchName -eq "master" -and
        $ENV:BHCommitMessage -match '!deploy'
    )
    {
        $Params = @{
            Path = $ProjectRoot
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
