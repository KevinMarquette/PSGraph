function Get-Indent
{
    [cmdletbinding()]
    param($depth=$script:indent)
    process
    {
        if( $null -eq $depth -or $depth -lt 0 )
        {
            $depth = 0
        }
        Write-Debug "Depth $depth"
        (" " * 4 * $depth )
    }
}