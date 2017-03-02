function inline 
{
    <#
        .Description
        Allows you to write native DOT format commands inline with proper indention

        .Example
        graph g {
            inline 'node [shape="rect";]' 
        }
        .Notes
        You can just place a string in the graph, but it will not indent correctly. So all this does is give you correct indents.
    #>
    param(
        # The text to generate inline with the graph
        [string[]]
        $InlineCommand
    )
    
    foreach($line in $InlineCommand)
    {
        "{0}{1}" -f (Get-Indent), $line
    }
}
