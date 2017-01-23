function Get-Node 
{
    param(
        [string[]]
        $Name = 'node',

        [hashtable]
        $Attributes    
    )

    $GraphVizAttribute = ConvertTo-GraphVizAttribute -Attributes $Attributes
    foreach($node in $Name)
    {
        '{0}"{1}" {2}' -f (Get-Indent), $node, $GraphVizAttribute
    }
}

Set-Alias -Name Node -Value Get-Node