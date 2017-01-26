function Get-SubGraph
{
    <#
        .Description
        A graph that is nested inside another graph to sub group elements

        .Example
        graph g {
            node top,bottom @{shape='rect'}
            subgraph 0 {
                node left,right
            }
            edge top -to left,right
            edge left,right -to bottom
        }

        .Notes
        This is just like the graph or digraph, except the name must match cluster_#
        The numbering must start at 0 and work up or the processor will fail.
    #>
    
    [cmdletbinding()]
    param(

        # Numeric ID of subgraph starting at 0
        [Parameter(
            Mandatory = $true, 
            Position = 0
        )]
        [int]
        $ID = 0,

        # Contents of the subgraph
        [Parameter(
            Mandatory = $true, 
            Position = 1
        )]
        [scriptblock]
        $ScriptBlock,

        # The attributes to apply to this subgraph
        [hashtable]
        $Attributes        
    )

    Graph -Name "cluster_$ID" -ScriptBlock $ScriptBlock -Attributes $Attributes -Type 'subgraph'
}