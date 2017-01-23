function Get-Indent
{
    param($depth=$script:indent)
    " " * 4 * $depth 
}