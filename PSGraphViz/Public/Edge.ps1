function Edge 
{
    <#
        .Description
        This defines an edge between two or more nodes

        .Example
        Graph g {
            Edge FirstNode SecondNode
        }

        Generates this graph syntax:

        digraph g {
            "FirstNode"->"SecondNode" 
        }
        .Example
        $folder = Get-ChildItem -Recurse -Directory
        graph g {
            $folder | %{ edge $_.name $_.parent }
        }

        .Example
        graph g {
            edge (1..3) (5..7)
            edge top bottom @{label="line label"}
            edge (10..13)
            edge one,two,three,four
        }

        .Notes
        If an array is specified for the From property, but not for the To property, then the From list will be procesed in order and will map the array in a chain.

    #>
    param(
        # start node or source of edge
        [Parameter(
            Mandatory = $true, 
            Position = 0
        )]
        [alias('NodeName','Name','SourceName','LeftHandSide','lhs')]
        [string[]]
        $From,

        # Destination node or target of edge
        [Parameter(
            Mandatory = $false, 
            Position = 1
        )]
        [alias('Destination','TargetName','RightHandSide','rhs')]
        [string[]]
        $To,

        # Hashtable that gets translated to an edge modifier
        [Parameter(
            Mandatory = $false, 
            Position = 2
        )]
        [hashtable]
        $Attributes
    )

    begin
    {
        if($Attributes -ne $null)
        {
            $GraphVizAttribute = ConvertTo-GraphVizAttribute -Attributes $Attributes
        }
    }

    process 
    {
        # If we only have one array, it needs to be processed differently
        if($To -ne $null)
        {
            foreach($sNode in $From)
            {
                foreach($tNode in $To)
                {
                    Write-Output ('{0}"{1}"->"{2}" {3}' -f (Get-Indent), $sNode, $tNode, $GraphVizAttribute)
                }
            }
        }
        else
        {
            for($index=0; $index -lt ($From.Count - 1); $index++)
            {
                Write-Output ('{0}"{1}"->"{2}" {3}' -f (Get-Indent), $From[$index], $From[$index + 1], $GraphVizAttribute)
            }
        }
    }
}
