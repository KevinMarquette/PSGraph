function Get-GraphVizArgument
{
    <#
        .Description
        Takes an array and converts it to commandline arguments for GraphViz

        .Example
        Get-GraphVizArgument -InputObject @{OutputFormat='jpg'}

        .Notes
        If no destination is provided, it will set the auto name flag.
        If there is no output format, it guesses from the destination
    #>
    
    [cmdletbinding()]
    param(
        [Parameter(
            ValueFromPipeline = $true,
            Position = 0
        )]
        [hashtable]
        $InputObject = @{}
    )

    process
    {        
        if($InputObject -ne $null)
        {
            $InputObject = Update-DefaultArgument -InputObject $InputObject  
            $arguments = Get-TranslatedArgument -InputObject $InputObject  
        }
                      
        return $arguments
    }
}