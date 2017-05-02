[cmdletbinding()]
param(
    [string]$Path = $pwd,
    [switch]$SkipPassing,
    [Switch]$ThrowOnFailure = $true
)

function Format-PesterTest 
{
    param(
        # A pester test result
        [Parameter(
            ValueFromPipeline = $true
        )]       
        $TestResult
    )

    process
    {
        Write-Host -NoNewline '['

        if($TestResult.Passed)
        {
            Write-Host 'Passed' -NoNewline -ForegroundColor Green
        }
        else 
        {
            Write-Host 'FAILED' -NoNewline -ForegroundColor Red
        }

        Write-Host ( '] {0}: {1}: {2}' -f $TestResult.Describe, $TestResult.Context, $TestResult.Name )

        if($TestResult.Passed -eq $false)
        {               
            Write-Host $TestResult.FailureMessage -ForegroundColor Yellow
            if($TestResult.StackTrace)
            {
                Write-Host $TestResult.StackTrace.ToString() -ForegroundColor Yellow
            }
        }
    }
}

$Tests = Get-ChildItem -Path $Path -Include *.Tests.ps1 -Recurse

$jobs = $Tests | Start-RSJob -Name {$_.BaseName}  -ScriptBlock {
    $test = $_
    Invoke-Pester -Script $test.FullName -PassThru -Show None -Tag Build | Add-Member -PassThru -Name Script -Value $test.FullName -MemberType NoteProperty
} 

$processed = New-Object 'System.Collections.Queue'

While( ( Get-RSJob -ID $jobs.ID ).Where({ $_.HasMoreData -or $_.State -eq 'Running' }) )
{
    Get-RSJob
    Write-Verbose 'sleep'
    Start-Sleep -Seconds 15
    $scriptResults = Get-RSJob -ID $jobs.ID -HasMoreData | Receive-RSJob
    
    # $script = $scriptResults[3]
    foreach( $script in $scriptResults)
    {
        Write-Output ( '[Script] {0}' -f $script.Script)
        # $result = $script.TestResult[0]
        $script.TestResult | Format-PesterTest

        if($script.FailedCount -gt 0 -and $ThrowOnFailure)
        {
            Write-Error ('Script {0} has {1} failing tests' -f $script.Script, $script.FailedCount)
        }
        $processed.Enqueue( $script )
    }
}

$failedTests = $processed.ToArray().TestResult.Where({$_.Passed -eq $false}) 
if($failedTests)
{
    Write-Host 'Please review these failed tests:'
    $failedTests | Format-PesterTest
    throw [System.Security.Policy.PolicyException]::new('Pester test(s) completed with failures')
}
