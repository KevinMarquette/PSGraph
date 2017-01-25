function Get-Graph  
{
    <#
        .Description
        Defines a graph. The base collection that holds all other graph elements

        .Example
        graph g {
            node top,left,right @{shape='rectangle'}
            rank left,right
            edge top left,right
        }

        .Example

        $dot = graph {
            edge hello world
        }

        .Notes
        The output is a string so it can be saved to a variable or piped to other commands
    #>
    [cmdletbinding()]
    param(

        # Name or ID of the graph
        [Parameter(
            Mandatory = $true, 
            Position = 0
        )]
        [string]
        $Name,

        # The commands to execute inside the graph
        [Parameter(
            Mandatory = $true, 
            Position = 1
        )]
        [scriptblock]
        $ScriptBlock,

        # Hashtable that gets translated to graph attributes
        [hashtable]
        $Attributes,

        # Keyword that initiates the graph
        [Parameter(
            DontShow = $true
        )]
        [string]
        $Type = 'digraph'
    )
    
    begin
    {
        if($Type -eq 'digraph')
        {
            $script:indent = 0
        }

        "" # Blank line
        "{0}{1} {2} {{" -f (Get-Indent), $Type, $name
        $script:indent++

        if($Attributes -ne $null)
        {
            ConvertTo-GraphVizAttribute -Attributes $Attributes -UseGraphStyle
        }

        "" # Blank line      
    }

    process
    {
        & $ScriptBlock
    }

    end
    {        
        $script:indent--
        "$(Get-Indent)}" # Close braces
        "" #Blank line
    }
}