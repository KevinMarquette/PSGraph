function Update-DefaultArgument
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( "PSUseShouldProcessForStateChangingFunctions", "" )]
    [cmdletbinding()]
    param ( $inputObject )

    if ( $InputObject.ContainsKey( 'LayoutEngine' ) )
    {
        Write-Verbose 'Looking up and replacing rendering engine string'
        $InputObject['LayoutEngine'] = Get-LayoutEngine -Name $InputObject['LayoutEngine']
    }

    if ( -Not $InputObject.ContainsKey( 'DestinationPath' ) )
    {
        $InputObject["AutoName"] = $true;
    }

    if ( -Not $InputObject.ContainsKey( 'OutputFormat' ) )
    {
        Write-Verbose "Tryig to set OutputFormat to match file extension"
        $outputFormat = Get-OutputFormatFromPath -Path $InputObject['DestinationPath']
        if ( $outputFormat )
        {
            $InputObject["OutputFormat"] = $outputFormat
        }
        else
        {
            $InputObject["OutputFormat"] = 'png'
        }
    }

    return $InputObject
}
