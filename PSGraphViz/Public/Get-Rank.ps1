function Get-Rank 
{
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

    $Values = foreach($item in ($Nodes + $AdditionalNodes))
    {
        # Adding the arrays ceates an empty element
        if(-Not [string]::IsNullOrWhiteSpace($item))
        {
            '"{0}"' -f $item
        }
    }    
    '{0}{{ rank=same;  {1}; }}' -f (Get-Indent), ($values -join ' ')
}
