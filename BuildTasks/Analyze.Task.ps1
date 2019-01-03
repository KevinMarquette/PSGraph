task Analyze {
    $params = @{
        IncludeDefaultRules = $true
        Path                = $ManifestPath
        Settings            = "$BuildRoot\ScriptAnalyzerSettings.psd1"
        Severity            = 'Warning'
    }

    "Analyzing $ManifestPath..."
    $results = Invoke-ScriptAnalyzer @params
    if ($results)
    {
        'One or more PSScriptAnalyzer errors/warnings were found.'
        'Please investigate or add the required SuppressMessage attribute.'
        $results | Format-Table -AutoSize
    }
}
