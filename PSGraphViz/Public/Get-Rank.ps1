function Get-Rank 
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
        [Parameter(
            Mandatory=$true, 
            ValueFromPipeline=$true,
            Position=0
        )]
        [string[]]
        $Nodes,

        # Used to catch alternate style of specifying nodes
        [Parameter(
            ValueFromRemainingArguments=$true, 
            Position=1
        )]
        [string[]]
        $AdditionalNodes
    )

    begin
    {
        $values = @()
    }
    
    process
    {
        $Values += foreach($item in ($Nodes + $AdditionalNodes))
        {
            # Adding these arrays ceates an empty element that we want to exclude
            if(-Not [string]::IsNullOrWhiteSpace($item))
            {
                '"{0}"' -f $item
            }
        }    
    } 

    end
    {
        Write-Output ('{0}{{ rank=same;  {1}; }}' -f (Get-Indent), ($values -join ' '))
    }  
}
