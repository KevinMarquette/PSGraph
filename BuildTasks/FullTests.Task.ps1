task FullTests {
    $params = @{
        CodeCoverage           = 'Output\*\*.psm1'
        CodeCoverageOutputFile = 'Output\codecoverage.xml'
        OutputFile             = $testFile
        OutputFormat           = 'NUnitXml'
        PassThru               = $true
        Path                   = 'Tests'
        Show                   = 'Failed', 'Fails', 'Summary'
        Tag                    = 'Build'
    }

    $results = Invoke-Pester @params
    if ($results.FailedCount -gt 0)
    {
        Write-Error -Message "Failed [$($results.FailedCount)] Pester tests."
    }

    $requiredPercent = $Script:CodeCoveragePercent
    $codeCoverage = $results.codecoverage.NumberOfCommandsExecuted / $results.codecoverage.NumberOfCommandsAnalyzed
    if($codeCoverage -lt $requiredPercent)
    {
        Write-Error ("Failed Code Coverage [{0:P}] below {1:P}" -f $codeCoverage,$requiredPercent)
    }
}
