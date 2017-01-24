function Node 
{
    <#
        .Description
        .Notes
        I had conflits trying to alias Get-Node to node, so I droped the verb from the name.
    #>
    param(
        # The name of the node
        [string[]]
        $Name = 'node',

        # Node attributes to apply to this node
        [hashtable]
        $Attributes    
    )

    $GraphVizAttribute = ConvertTo-GraphVizAttribute -Attributes $Attributes
    foreach($node in $Name)
    {
        '{0}"{1}" {2}' -f (Get-Indent), $node, $GraphVizAttribute
    }
}
