function ConvertTo-GraphVizAttribute
{
    param(
        [hashtable]
        $Attributes,

        [switch]
        $UseGraphStyle,

        [object]
        $InputObject
    )

    

    if($Attributes -ne $null -and $Attributes.Keys.Count -gt 0)
    {

        $values = $Attributes.GetEnumerator() | ForEach-Object {'{0}="{1}";'-f $_.name, $_.value}

        $values = foreach($key in $Attributes.GetEnumerator())
        {
            if($key.value -is [scriptblock])
            {
                Write-Debug "Executing Script on Key ($key.name)"
                '{0}="{1}";'-f $key.name, ((@($InputObject).ForEach($key.value)))  
            }
            else 
            {
                '{0}="{1}";'-f $key.name, $key.value
            }
        }

        if($UseGraphStyle)
        {
            $indent = Get-Indent
            $values | ForEach-Object{"$indent$_"}
        }
        else 
        {
            "[{0}]" -f ($values -join '')
        }            
        
    }
}
