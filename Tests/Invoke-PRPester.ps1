[cmdletbinding()]
param(
    [string]$Path = $pwd,
    [switch]$SkipPassing,
    [Switch]$ThrowOnFailure = $true
)

$Tests = Get-ChildItem -Path $Path -Include *.Tests.ps1 -Recurse

$jobs = $Tests | Start-RSJob -Name {$_.BaseName}  -ScriptBlock {
    $test = $_
    Invoke-Pester -Script $test.FullName -PassThru -Show None -Tag Build | Add-Member -PassThru -Name Script -Value $test.FullName -MemberType NoteProperty
} 

#$failed = New-Object 'System.Collections.Queue'
$scriptResults = $jobs | Wait-RSJob | Receive-RSJob

# $script = $scriptResults[3]
foreach( $script in $scriptResults)
{
    Write-Output ( '[Script] {0}' -f $script.Script)
    # $result = $script.TestResult[0]
    foreach($result in $script.TestResult)
    {        
        if($result.Passed)
        {
            if ( -Not $SkipPassing )
            {
                Write-Output ( '[Passed] {0}: {1}: {2}' -f $result.Describe, $result.Context, $result.Name )
            }               
        }
        else
        {
            Write-Output ( '[FAILED] {0}: {1}: {2}' -f $result.Describe, $result.Context, $result.Name )
            Write-Output $result.FailureMessage
            if($result.StackTrace)
            {
                Write-Output $result.StackTrace
            }
        }
    }

    if($script.FailedCount -gt 0 -and $ThrowOnFailure)
    {
        throw [System.Security.Policy.PolicyException]::new(('Script {0} has {1} failing tests' -f $script.Script,$script.FailedCount))
    }
}
