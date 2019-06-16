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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueForMandatoryParameter", "")]
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
        $Attributes = @{},

        #Specify the the shape for the node - graphviz selects oval by default
        [Parameter()]
        [ValidateSet('box', 'polygon', 'ellipse', 'oval', 'circle', 'point', 'egg', 'triangle', 'plaintext', 'plain', 'diamond',
                     'trapezium', 'parallelogram', 'house', 'pentagon', 'hexagon', 'septagon', 'octagon', 'doublecircle',
                     'doubleoctagon', 'tripleoctagon', 'invtriangle', 'invtrapezium', 'invhouse', 'Mdiamond', 'Msquare',
                     'Mcircle', 'rect', 'rectangle', 'square', 'star', 'none', 'underline', 'cylinder', 'note', 'tab',
                     'folder', 'box3d', 'component', 'promoter', 'cds', 'terminator', 'utr', 'primersite', 'restrictionsite',
                     'fivepoverhang', 'threepoverhang', 'noverhang', 'assembly', 'signature', 'insulator', 'ribosite',
                     'rnastab', 'proteasesite', 'proteinstab', 'rpromoter', 'rarrow', 'larrow', 'lpromoter')]
        [string]
        $Shape,

        [Parameter()]
        [string]
        $Label,

        # When multiple nodes are supplied, automatically add them nodes to a rank
        [Parameter()]
        [alias('Rank')]
        [switch]
        $Ranked,

        # not used anymore but offers backward compatibility or verbosity
        [switch]
        $Default
    )
    begin
    {
         #re-create any scriptblock passed as a parameter, otherwise variables in this function are out of its scope.
        if ($NodeScript)
        {
            $Nodescript = [scriptblock]::create( $NodeScript )
        }
    }
    process
    {
        try
        {

            if (
                $Name.count -eq 1 -and
                $Name[0] -is [hashtable] -and
                !$PSBoundParameters.ContainsKey( 'NodeScript' )
            )
            {
                # detected attept to set default values in this form 'node @{key=value}', the hashtable ends up in $name[0]
                $Attributes = $Name[0]
                $Name[0] = 'node'
            }
            # don't want to add every attribute as a parameter just the most common for a node Changed handling when the sole parameter holds attributes to make this easier
            #Turn Shape or Label into Attributes - and allow for label being an empty string (i.e. boolean False !)
            if ($PSBoundParameters.ContainsKey('Label')) {
                $Attributes['label'] = $label
            }
            if ($PSBoundParameters.ContainsKey('Shape')) {
                $Attributes['shape'] = $Shape.ToLower()
            }
            $nodeList = @()
            foreach ( $node in $Name )
            {
                if ( $NodeScript )
                {
                    $nodeName = (@($node).ForEach($NodeScript))
                }
                else
                {
                    $nodeName = $node
                }


                $GraphVizAttribute = ConvertTo-GraphVizAttribute -Attributes $Attributes -InputObject $node
                '{0}{1} {2}' -f (Get-Indent), (Format-Value $nodeName -Node), $GraphVizAttribute

                $nodeList += $nodeName
            }

            if ($Ranked -and $null -ne $nodeList -and $nodeList.count -gt 1)
            {
                Rank -Nodes $nodeList
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSitem )
        }
    }
}
