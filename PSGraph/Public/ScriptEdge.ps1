function ScriptEdge 
{
    <#
        .Description
        Creates edges based on the properties of an object

        .Example
        $folders = Get-ChildItem -Directory -Recurse
        graph folders {
            scriptedge $folders -From {$_.parent} -To {$_.name}
        }

        .Notes
        Script blocks are used to define each side of the edge
        If a script block produces an array, then all of those items will be listeded individualy and linked

    #>
    param(
        # a list of nodes to process
        [Parameter(
            Mandatory = $true, 
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Node,

        # start node script or source of edge
        [Parameter()]
        [alias('FromScriptBlock','From','SourceScript','LeftHandSide','lhs')]
        [scriptblock]
        $FromScript = {$_.ToString()},

        # Destination node script or target of edge
        [Parameter()]
        [alias('ToScriptBlock','To','TargetScript','RightHandSide','rhs')]
        [scriptblock]
        $ToScript = {$_.ToString()},

        # Hashtable that gets translated to an edge modifier
        [Parameter(
            Mandatory = $false, 
            Position = 1
        )]
        [hashtable]
        $Attributes
    )

    process 
    {
        foreach($item in $Node)
        {            
            $fromValue = (@($item).ForEach($FromScript))
            $toValue = (@($item).ForEach($ToScript))
            edge -From $fromValue -To $toValue -Attributes $Attributes
        }
    }
}