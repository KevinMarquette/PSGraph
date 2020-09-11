function Get-TranslatedArgument( $InputObject )
{
    $paramLookup = Get-ArgumentLookUpTable

    Write-Verbose 'Walking parameter mapping'
    foreach ( $key in $InputObject.keys )
    {
        Write-Debug $key
        #A hashtable key can't be null. Don't pass null or empty string. (But allow zero, false etc.)
        #This means we can get output to std-out by making the destination an empty string.
        if ( -not [string]::IsNullOrEmpty($InputObject[$key]) -and $paramLookup.ContainsKey( $key ) )
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
