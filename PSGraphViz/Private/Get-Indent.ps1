function Get-Indent
{
    [cmdletbinding()]
    param($depth=$script:indent)

    Write-verbose "Indent: $depth"
    " " * 4 * $depth 
}