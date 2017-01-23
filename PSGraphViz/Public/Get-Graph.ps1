function Get-Graph  
{
    [cmdletbinding()]
    param(
        [string]
        $Name,

        [scriptblock]
        $ScriptBlock,

        [hashtable]
        $Attributes,

        [string]
        $type = 'digraph'
    )
    
    begin
    {
        if($type -eq 'digraph')
        {
            $script:indent = 0
        }

        "" # Blank line
        "{0}{1} {2} {{" -f (Get-Indent), $type, $name
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