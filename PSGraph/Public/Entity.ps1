
Enum EntityType
{
    Name
    Value
    TypeName
}

Function Entity
{
    <#
    .SYNOPSIS
    Convert an object into a PSGraph Record
    
    .DESCRIPTION
    Convert an object into a PSGraph Record
    
    .PARAMETER InputObject
    The object to convert into a record

    .PARAMETER Name
    The name of the node
    
    .PARAMETER Show
    The different details to show in the record.

    Name : The property name
    Value : The property name and value
    TypeName : The property name and the value type
    
    .PARAMETER Property
    The list of properties to display. Default is to list them all.
    Supports wildcards.

    .EXAMPLE
    
    $sample = [pscustomobject]@{
        first = 1
        second = 'two'
    }
    graph {
        $sample |  Entity -Show TypeName
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

        [string]
        $Name,

        [string[]]
        $Property,

        [EntityType]
        $Show = [EntityType]::TypeName
    )

    end
    {
        if([string]::isnullorempty($Name) )
        {
            $Name = $InputObject.GetType().Name
        }

        if($InputObject -is [System.Collections.IDictionary])
        {
            $members = $InputObject.keys
        }
        else 
        {
            $Members = $InputObject.PSObject.Properties.Name
        }
        
        $rows = foreach ($propertyName in $members)
        {
            if($null -ne $Property)
            {
                $matches = $property | Where-Object {$propertyName -like $_}
                if($null -eq $matches)
                {
                    continue
                }
            }
            
            switch ($Show)
            {
                Name
                {
                    Row "<B>$propertyName</B>" -Name $propertyName
                }
                TypeName
                {
                    Row ('<B>{0}</B> <I>[{1}]</I>' -f $propertyName, $property.TypeNameOfValue) -Name $propertyName
                }
                Value
                {
                    Row ('<B>{0}</B> : <I>{1}</I>' -f $propertyName, $inputobject.($propertyName)) -Name $propertyName
                }
            }
        }

        Record -Name $Name -Row $rows
    }
}
