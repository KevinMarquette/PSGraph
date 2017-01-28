function ScriptEdge 
{
    <#
        .Description
        Like edge but with scripts

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
            edge -From (@($item).ForEach($FromScript)) -To (@($item).ForEach($ToScript)) -Attributes $Attributes
        }
    }
}