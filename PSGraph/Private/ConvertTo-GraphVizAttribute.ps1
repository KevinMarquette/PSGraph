function ConvertTo-GraphVizAttribute
{
    <#
        .Description
        Converts a hashtable to a key value pair format that the DOT specification uses for nodes, edges and graphs

        .Example
            ConvertTo-GraphVizAttribute @{label='myName'}

            [label="myName";]

             For edge and nodes, it like this [key1="value";key2="value"]

        .Example
            ConvertTo-GraphVizAttribute @{label='myName';color='Red'} -UseGraphStyle

                label="myName";
                color="Red";

            For graphs, it needs to be indented and multiline
            key1="value";
            key2="value";

        .Example
            ConvertTo-GraphVizAttribute @{label={$_.name}} -InputObject @{name='myName'}

            [label="myName";]

            Script blocks are supported in the hashtable for some commands.
            InputObject is the $_ value in the scriptblock

        .Notes
        For edge and nodes, it like this [key1="value";key2="value"]
        For graphs, it needs to be indented and multiline
            key1="value";
            key2="value";

        Script blocks are supported in the hashtable for some commands.
        InputObject is the $_ value in the scriptblock
    #>
    param(
        [hashtable]
        $Attributes = @{},

        [switch]
        $UseGraphStyle,

        # used for whe the attributes have scriptblocks embeded
        [object]
        $InputObject,

        # source node for cluster edge detection
        [string]
        $From,

        # target node for cluster edge detection
        [string]
        $To
    )

    if ($null -eq $script:SubGraphList)
    {
        $script:SubGraphList = @{}
    }
    if ( $From -and $script:SubGraphList.contains($From) )
    {        
        $Attributes.ltail = $script:SubGraphList[$From]        
    }
    if ( $To -and $script:SubGraphList.contains($To) )
    {        
        $Attributes.lhead = $script:SubGraphList[$To]        
    }
    
    if ($Attributes -ne $null -and $Attributes.Keys.Count -gt 0)
    {
        $values = foreach ( $key in $Attributes.GetEnumerator() )
        {
            if ($key.value -is [scriptblock])
            {
                Write-Debug "Executing Script on Key $($key.name)"
                $value = ( [string]( @( $InputObject ).ForEach( $key.value ) ) )
            }
            else
            {
                $value = $key.value
            }
            '{0}={1};' -f $key.name, ( Format-Value $value )
        }

        if ( $UseGraphStyle )
        {
            # Graph style is each line on its own and no brackets
            $indent = Get-Indent
            $values | ForEach-Object {"$indent$_"}
        }
        else
        {
            "[{0}]" -f ( $values -join '' )
        }

    }
}
