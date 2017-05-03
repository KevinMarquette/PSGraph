function SubGraph
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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueForMandatoryParameter", "")]
    [cmdletbinding(DefaultParameterSetName = 'Default')]
    param(
        # Numeric ID of subgraph starting at 0
        [Parameter(
            Mandatory = $true, 
            Position = 0
        )]
        [int]
        $ID,

        # The commands to execute inside the subgraph
        [Parameter(
            Mandatory = $true, 
            Position = 1,
            ParameterSetName = 'Default'
        )]
        [Parameter(
            Mandatory = $true, 
            Position = 2,
            ParameterSetName = 'Attributes'
        )]
        [scriptblock]
        $ScriptBlock,

        # Hashtable that gets translated to graph attributes
        [Parameter(
            ParameterSetName = 'Default'
        )]
        [Parameter(             
            Mandatory = $true, 
            Position = 1,
            ParameterSetName = 'Attributes'
        )]
        [hashtable]
        $Attributes = @{}
    )

    process
    {
        try
        {
            Graph -Name "cluster_$ID" -ScriptBlock $ScriptBlock -Attributes $Attributes -Type 'subgraph'
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
}
