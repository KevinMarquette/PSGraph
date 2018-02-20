
# Entity [object]

The `Entity` command takes an object and maps it into a `Record`. This turned out to be a common pattern in how I was trying to use the `Record`.

    $object = [PSCustomObject]@{
        First = 'Kevin'
        Last = 'Marquette'
        Age = 37
    }

    Graph {
        Entity $object
    } | Show-PSGraph

![An entity showing a PSCustomObject](/img/entitytypename.png)

## Entity [object] -Show [enum]

I provide 3 different views of the object with the `-Show` parameter. Here are the possible options.

* `Name` - Property name
* `TypeName` - Name and value type
* `Value` - Name and value

Here is the same object showing the values.

    Graph {
        Entity $object -Name 'Person' -Show Value
    } | Show-PSGraph

![An entity showing the object values](/img/entityvalue.png)

The entity will automatically name each row with the property name. This will allow you to draw edges directly to them. I have a more complex example at the end of this article that shows this in action.

## Entity [object] -Name [string]

If you have a small collection of objects that you want to place on a graph, make sure you give each one a custom name.

    $servers = Import-CSV .\myservers.csv

    Graph {
        $servers | ForEach-Object {
            Entity $PSItem -Name $PSItem.ComputerName
        }
    }

## Entity [object] -Property [string[]]

The `-Property` parameter allows for easy filtering of the properties that you want to display.

    Entity $Server -Property ComputerName, CPU, Memory, IP, Location
