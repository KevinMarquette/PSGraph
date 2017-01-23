

function SubGraph
{
    param(
        [string]
        $ID = 0,

        [scriptblock]
        $ScriptBlock        
    )
    Graph -Name "Cluster_$ID" -ScriptBlock $ScriptBlock -Type 'subgraph'
}

function Edge 
{

    param(
        [string[]]
        $From,

        [string[]]
        $To,

        [hashtable]
        $Attributes
    )

    if($Attributes -ne $null)
    {
        $GraphVizAttribute = ConvertTo-GraphVizAttribute -Attributes $Attributes
    }

    if($To -ne $null)
    {
        foreach($sNode in $From)
        {
            foreach($tNode in $To)
            {
                '{0}"{1}"->"{2}" {3}' -f (Get-Indent), $sNode, $tNode, $GraphVizAttribute
            }
        }
    }
    else
    {
        for($index=0; $index -lt ($From.Count - 1); $index++)
        {
            '{0}"{1}"->"{2}" {3}' -f (Get-Indent), $From[$index], $From[$index + 1], $GraphVizAttribute
        }
    }
}

function Node 
{
    param(
        [string[]]
        $Name = 'node',

        [hashtable]
        $Attributes    
    )

    $GraphVizAttribute = ConvertTo-GraphVizAttribute -Attributes $Attributes
    foreach($node in $Name)
    {
        '{0}"{1}" {2}' -f (Get-Indent), $node, $GraphVizAttribute
    }
}

function ConvertTo-GraphVizAttribute
{
    param(
        [hashtable]
        $Attributes,

        [switch]
        $UseGraphStyle
    )

    if($Attributes -ne $null -and $Attributes.Keys.Count -gt 0)
    {
        if($UseGraphStyle)
        {
            $Attributes.GetEnumerator() | ForEach-Object {'{0}{1}="{2}";'-f (Get-Indent), $_.name, $_.value}
        }
        else
        {
            $values = $Attributes.GetEnumerator() | ForEach-Object {'{0}="{1}"'-f $_.name, $_.value}
            "[{0}]" -f ($values -join ';')
        }
    }
}

function Get-Indent
{
    param($depth=$script:indent)
    " " * 4 * $depth 
}