function Get-GraphVizArguments
{
    [cmdletbinding()]
    param(
        [hashtable]
        $InputObject
    )

    $paramLookup = @{
        # OutputFormat
        Version = 'V'
        Debug = 'v'
        GraphName = 'Gname={0}'
        NodeName = 'Nname={0}'
        EdgeName = 'Ename={0}'
        OutputFormat = 'T{0}'
        LayoutEngine = 'K{0}'
        ExternalLibrary = 'l{0}'
        DestinationPath = 'o{0}'
        AutoName = 'O'

        #LayoutEngine
        Hierarchical = 'dot'
        SpringModelSmall = 'neato'
        SpringModelMedium = 'fdp'
        SpringModelLarge = 'sfdp'
        Radial = 'twopi'
        Circular = 'circo'
    }
    $arguments = @()
    
    if($InputObject.ContainsKey('LayoutEngine'))
    {
        Write-Verbose 'Looking up and replacing rendering engine string'
        $InputObject['LayoutEngine'] = $paramLookup[$InputObject['LayoutEngine']]
    }

    if( -Not $InputObject.ContainsKey('DestinationPath'))
    {
        $InputObject["AutoName"] = $true;
    }

    if( -Not $InputObject.ContainsKey('OutputFormat'))
    {
        Write-Verbose "Tryig to set OutputFormat to match file extension"
        $InputObject["OutputFormat"] = $OutputFormat;
        $formats = @('jpg','png','gif','imap','cmapx','jp2','json','pdf','plain','dot')

        foreach($ext in $formats)
        {
            if($DestinationPath -like "*.$ext")
            {
                $InputObject["OutputFormat"] = $ext
            }
        }
    }

    Write-Verbose 'Walking parameter mapping'
    foreach($key in $InputObject.keys)
    {
        Write-Debug $key
        if($key -ne $null -and $paramLookup.ContainsKey($key))
        {
            $newArgument = $paramLookup[$key]
            if($newArgument -like '*{0}*')
            {
                $newArgument = $newArgument -f $InputObject[$key]
            }

            Write-Debug $newArgument
            $arguments += "-$newArgument"
        }            
    }

    return $arguments
}