function Get-Rank 
{
    param(
        [string[]]
        $Nodes
    )

    $Values = $Nodes | ForEach-Object{'"{0}"' -f $_}
    '{0}{{ rank=same;  {1}; }}' -f (Get-Indent), ($values -join ' ')
}