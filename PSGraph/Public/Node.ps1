function Node 
{
    <#
        .Description
        Used to specify a nodes attributes or placement within the flow.

        .Example
        graph g {
            node one,two,three
        }

        .Example
        graph g {
            node top @{shape='house'}
            node middle
            node bottom @{shape='invhouse'}
            edge top,middle,bottom
        }

        .Example
        
        graph g {
            node (1..10) 
        }

        .Notes
        I had conflits trying to alias Get-Node to node, so I droped the verb from the name.
        If you have subgraphs, it works best to define the node inside the subgraph before giving it an edge
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueForMandatoryParameter","")]
    [cmdletbinding()]
    param(
        # The name of the node
        [Parameter(
            Mandatory = $true, 
            ValueFromPipeline = $true,
            Position = 0
        )]
        [object[]]
        $Name = 'node',

        # Script to run on each node
        [Parameter()]
        [alias('Script')]
        [scriptblock]
        $NodeScript = {$_},

        # Node attributes to apply to this node
        [Parameter(Position = 1)]
        [hashtable]
        $Attributes,

        # not used anymore but offers backward compatibility or verbosity
        [switch]
        $Default 
    )

    process
    {        
        if($Name.count -eq 1 -and $Name[0] -is [hashtable] -and !$PSBoundParameters.ContainsKey('NodeScript'))
        { 
            # detected attept to set default values in this form 'node @{key=value}', the hashtable ends up in $name[0]
            Node node -Attributes $Name[0] 
        }
        else
        {

            foreach($node in $Name)
            {
            
                if($NodeScript)
                {
                    $nodeName = [string](@($node).ForEach($NodeScript))
                }
                else 
                {
                    $nodeName = $node
                }

                $GraphVizAttribute = ConvertTo-GraphVizAttribute -Attributes $Attributes -InputObject $node
                Write-Output ('{0}{1} {2}' -f (Get-Indent), (Format-Value $nodeName -Node), $GraphVizAttribute)                           
            }   
        }     
    }
}
