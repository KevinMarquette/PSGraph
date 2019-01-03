task Pester {
    $requiredPercent = $Script:CodeCoveragePercent

    $params = @{
        OutputFile             = $testFile
        OutputFormat           = 'NUnitXml'
        PassThru               = $true
        Path                   = 'Tests'
        Show                   = 'Failed', 'Fails', 'Summary'
        Tag                    = 'Build'
    }

    if($requiredPercent -gt 0.00)
    {
        $params['CodeCoverage'] = 'Output\*\*.psm1'
        $params['CodeCoverageOutputFile'] = 'Output\codecoverage.xml'
    }

    $results = Invoke-Pester @params
    if ($results.FailedCount -gt 0)
    {
        Write-Error -Message "Failed [$($results.FailedCount)] Pester tests."
    }

    if($results.codecoverage.NumberOfCommandsAnalyzed -gt 0)
    {
        $codeCoverage = $results.codecoverage.NumberOfCommandsExecuted / $results.codecoverage.NumberOfCommandsAnalyzed

        if($codeCoverage -lt $requiredPercent)
        {
            Write-Error ("Failed Code Coverage [{0:P}] below {1:P}" -f $codeCoverage,$requiredPercent)
        }
    }
}
