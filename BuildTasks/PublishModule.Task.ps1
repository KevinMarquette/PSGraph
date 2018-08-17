task PublishModule {

    if ( $ENV:BHBuildSystem -ne 'Unknown' -and
        $ENV:BHBranchName -eq "master" -and
        [string]::IsNullOrWhiteSpace($ENV:APPVEYOR_PULL_REQUEST_NUMBER) -and
        -not [string]::IsNullOrWhiteSpace($ENV:NugetApiKey))
    {
        $publishModuleSplat = @{
            Path        = $Destination
            NuGetApiKey = $ENV:NugetApiKey
            Verbose     = $true
            Force       = $true
            Repository  = $PSRepository
            ErrorAction = 'Stop'
        }
        Publish-Module @publishModuleSplat
    }
    else
    {
        "Skipping deployment: To deploy, ensure that...`n" +
        "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
        "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
        "`t* This is not a pull request"
    }
}
