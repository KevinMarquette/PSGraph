Function New-QuickGraph
{
    <#
    .Description
    This generates a quick graph from an input object. Specify the properties of the object that represent the left and right side of the mapping.

    .Example
    $folders = Get-ChildItem -Recuse -Directory 
    $folders | New-QuickGraph -LeftProperty Parent -RightProperty Name | Set-Content -Path Folder.vz
    Invoke-GraphViz -Path folder.vz -OutputFormat png
    #>
    [cmdletbinding()]
    param(

        # the object to process
        [parameter(
            ValueFromPipeline
        )]
        [object[]]
        $InputObject,

        # the source node
        [alias("LHS")]
        [string[]]
        $LeftProperty,

        # the target node
        [alias("RHS")]
        [string[]]
        $RightProperty,

        # turns off the graph headder incase you want to just generate the body
        [switch]
        $SkipGraphHeadder
    )

    begin
    {
        if(-NOT $SkipGraphHeadder)
        {
            'digraph G {'
            'node [shape="rect"]'
            ''
        }
    }

    process
    {
        foreach($node in $InputObject)
        {
            foreach($rhs in $RightProperty)
            {
                foreach($lhs in $LeftProperty)
                {
                    '    "{0}" -> "{1}"' -f $node.$lhs, $node.$rhs
                }
            }
        }
    }

    end
    {
        if(-NOT $SkipGraphHeadder)
        {
            '}'
        }
    }
}