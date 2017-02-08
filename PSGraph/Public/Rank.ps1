function Rank
{
    <#
        .Description
        Places specified nodes at the same level on the chart as a way to give some guidance to node layout

        .Example
        graph g {
            rank 1,3,5,7
            rank 2,4,6,8
            edge (1..8)
        }

        .Example
        $odd = @(1,3,5,7)
        $even = @(2,4,6,8)

        graph g {
            rank $odd
            rank $even
            edge $odd -to $even
        }

        .Notes
        Accepts an array of items or a list of strings.
    #>

    [cmdletbinding()]
    param(

        # List of nodes to be on the same level as each other
        [Parameter(
            Mandatory=$true, 
            ValueFromPipeline=$true,
            Position=0
        )]
        [object[]]
        $Nodes,

        # Used to catch alternate style of specifying nodes
        [Parameter(
            ValueFromRemainingArguments=$true, 
            Position=1
        )]
        [object[]]
        $AdditionalNodes,

        # Script to run on each node
        [alias('Script')]
        [scriptblock]
        $NodeScript = {$_}
    )

    begin
    {
        $values = @()
    }
    
    process
    {
        $itemList = New-Object System.Collections.Queue
        if($null -ne $Nodes)
        {
            $Nodes | ForEach-Object{$_} | ForEach-Object{$itemList.Enqueue($_)}
        }
        if($null -ne $AdditionalNodes)
        {
            $AdditionalNodes | ForEach-Object{$_} | ForEach-Object{$_} | ForEach-Object{$itemList.Enqueue($_)}
        }

        $Values += foreach($item in $itemList)
        {
            # Adding these arrays ceates an empty element that we want to exclude
            if(-Not [string]::IsNullOrWhiteSpace($item))
            {
                if($NodeScript)
                {
                    $nodeName = [string](@($item).ForEach($NodeScript))
                }
                else 
                {
                    $nodeName = $item
                }

                Format-Value $nodeName -Node
            }
        }    
    } 

    end
    {
        Write-Output ('{0}{{ rank=same;  {1}; }}' -f (Get-Indent), ($values -join '; '))
    }  
}
