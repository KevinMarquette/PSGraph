function Get-Indent
{
    [cmdletbinding()]
    param($depth=$script:indent)
    process
    {
        if($depth -eq $null -or $depth -lt 0)
        {
            $depth = 0
        }
        Write-Debug "Depth $depth"
        (" " * 4 * $depth )
    }
}