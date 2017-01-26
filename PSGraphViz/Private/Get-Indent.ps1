function Get-Indent
{
    [cmdletbinding()]
    param($depth=$script:indent)
    process
    {
        Write-Warning "Depth $depth"
    (" " * 4 * $depth )
    }
    
}