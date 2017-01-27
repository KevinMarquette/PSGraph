function Update-DefaultArguments
{
    [cmdletbinding()]
    param($inputObject,$EnsureDestination)
    
    if($InputObject.ContainsKey('LayoutEngine'))
    {
        Write-Verbose 'Looking up and replacing rendering engine string'
        $InputObject['LayoutEngine'] = Get-LayoutEngine -Name $InputObject['LayoutEngine']
    }

    if( -Not $InputObject.ContainsKey('DestinationPath'))
    {
        $InputObject["AutoName"] = $true;
    }

    if( -Not $InputObject.ContainsKey('OutputFormat'))
    {
        Write-Verbose "Tryig to set OutputFormat to match file extension"
        $outputFormat = Get-OutputFormatFromPath -Path $InputObject['DestinationPath']
        if($outputFormat)
        {
            $InputObject["OutputFormat"] = $outputFormat
        }
        else 
        {
            $InputObject["OutputFormat"] = 'png'
        }
    }

    if($EnsureDestination)
    {
        if(-Not $PSBoundParameters.ContainsKey('DestinationPath'))
        {
            $outputFormat = $InputObject["OutputFormat"]
            $file = [System.IO.Path]::GetRandomFileName()               
            $PSBoundParameters["DestinationPath"] = Join-Path $env:temp "$file.$outputFormat"            
        }
    }

    return $InputObject
}