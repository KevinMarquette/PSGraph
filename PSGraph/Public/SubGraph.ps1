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
        # Name of subgraph
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'Named'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'NamedAttributes'
        )]
        [alias('ID')]
        $Name,

        # The commands to execute inside the subgraph
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'Default'
        )]        
        [Parameter(
            Mandatory = $true,
            Position = 1,
            ParameterSetName = 'Named'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 1,
            ParameterSetName = 'Attributes'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 2,
            ParameterSetName = 'NamedAttributes'
        )]
        [scriptblock]
        $ScriptBlock,

        # Hashtable that gets translated to graph attributes
        [Parameter(
            Mandatory = $true,
            Position = 1,
            ParameterSetName = 'NamedAttributes'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'Attributes'
        )]
        [hashtable]
        $Attributes = @{}
    )

    process
    {
        try
        {
            if ( $null -eq $Name )
            {
                $name = ((New-Guid ) -split '-')[4]
            }

            Graph -Name "cluster$Name" -ScriptBlock $ScriptBlock -Attributes $Attributes -Type 'subgraph'
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSitem )
        }
    }
}
