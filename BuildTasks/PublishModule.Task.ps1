task PublishModule {

    if ( $ENV:BHBuildSystem -ne 'Unknown' -and
        $ENV:BHBranchName -eq "master" -and
        -not [string]::IsNullOrWhiteSpace($ENV:nugetapikey))
    {
        $publishModuleSplat = @{
            Path        = $Destination
            NuGetApiKey = $ENV:nugetapikey
            Verbose     = $true
            Force       = $true
            Repository  = $PSRepository
            ErrorAction = 'Stop'
        }
        "Files in module output:"
        Get-ChildItem $Destination -Recurse -File |
            Select-Object -Expand FullName

        "Publishing [$Destination] to [$PSRepository]"

        Publish-Module @publishModuleSplat
    }
    else
    {
        "Skipping deployment: To deploy, ensure that...`n" +
        "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
        "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
        "`t* The repository APIKey is defined in `$ENV:nugetapikey (Current: $(![string]::IsNullOrWhiteSpace($ENV:nugetapikey))) `n" +
        "`t* This is not a pull request"
    }
}
