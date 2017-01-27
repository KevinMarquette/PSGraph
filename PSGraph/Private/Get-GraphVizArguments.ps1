function Get-GraphVizArguments
{
    <#
        .Description
        Takes an array and converts it to commandline arguments for GraphViz

        .Example
        Get-GraphVizArguments -InputObject @{OutputFormat='jpg'}

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
            $InputObject = Update-DefaultArguments -InputObject $InputObject         
            $arguments = Get-TranslatedArguments -InputObject $InputObject  
        }
                      
        return $arguments
    }
}