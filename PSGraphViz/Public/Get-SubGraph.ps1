function Get-SubGraph
{
    param(
        [string]
        $ID = 0,

        [scriptblock]
        $ScriptBlock,

        [hashtable]
        $Attributes        
    )

    Get-Graph -Name "cluster_$ID" -ScriptBlock $ScriptBlock -Attributes $Attributes -Type 'subgraph'
}