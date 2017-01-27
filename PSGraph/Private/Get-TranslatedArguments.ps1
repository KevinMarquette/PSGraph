function Get-TranslatedArguments($InputObject)
{
    $paramLookup = Get-ArgumentLookUpTable
    $arguments = @()

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
            Write-Output "-$newArgument"
        }            
    }
}