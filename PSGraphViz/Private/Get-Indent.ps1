function Get-Indent
{
    [cmdletbinding()]
    param($depth=$script:indent)
    process
    {
        Write-Debug "Depth $depth"
        (" " * 4 * $depth )
    }
}