
Enum EntityType
{
    Name
    Value
    TypeName
}

Function EntityObject
{
    <#
    .SYNOPSIS
    Convert an object into a PSGraph Record
    
    .DESCRIPTION
    Convert an object into a PSGraph Record
    
    .PARAMETER InputObject
    The object to convert into a record
    
    .PARAMETER Show
    The different details to show in the record
    
    .EXAMPLE
    
    $p = [pscustomobject]@{
        first = 1
        second = 'two'
    }
    graph {
        $p |  EntityObject $p -Show TypeName  
    } | export-PSGraph -ShowGraph
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [parameter(
            ValueFromPipeline,
            position = 0
        )]
        $InputObject,

        [EntityType]
        $Show = [EntityType]::TypeName
    )

    end
    {
        $Name = $InputObject.GetType().Name
        $Members = $InputObject.PSObject.Properties
        
        $rows = foreach ($property in $members)
        {
            $propertyName = $property.name
            switch ($Show)
            {
                Name
                {
                    Row "<B>$propertyName</B>" -ID $propertyName
                }
                TypeName
                {
                    Row ('<B>{0}</B> <I>[{1}]</I>' -f $propertyName, $property.TypeNameOfValue) -ID $propertyName
                }
                Value
                {
                    Row ('<B>{0}</B> : <I>{1}</I>' -f $propertyName, $inputobject.($propertyName)) -ID $propertyName
                }
            }
        }

        Record -Name $Name -List $rows
    }
}
