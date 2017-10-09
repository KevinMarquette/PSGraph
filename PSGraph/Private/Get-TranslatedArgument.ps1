function Get-TranslatedArgument( $InputObject )
{
    $paramLookup = Get-ArgumentLookUpTable

    Write-Verbose 'Walking parameter mapping'
    foreach ( $key in $InputObject.keys )
    {
        Write-Debug $key
        if ( $null -ne $key -and $paramLookup.ContainsKey( $key ) )
        {
            $newArgument = $paramLookup[$key]
            if ( $newArgument -like '*{0}*' )
            {
                $newArgument = $newArgument -f $InputObject[$key]
            }

            Write-Debug $newArgument
            "-$newArgument"
        }
    }
}
