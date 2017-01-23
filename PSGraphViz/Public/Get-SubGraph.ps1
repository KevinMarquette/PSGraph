function Get-SubGraph
{
    param(
        [string]
        $ID = 0,

        [scriptblock]
        $ScriptBlock        
    )
    Get-Graph -Name "Cluster_$ID" -ScriptBlock $ScriptBlock -Type 'subgraph'
}