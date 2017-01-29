function inline 
{
    <#
        .Description
        Allows you to write native DOT format commands inline with proper indention

        .Notes
        You can just place a string in the graph, but it will not indent correctly. So all this does is give you correct indents.
    #>
    param([string[]]$InlineCommand)
    
    foreach($line in $InlineCommand)
    {
        "{0}{1}" -f (Get-Indent), $line
    }
}