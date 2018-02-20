# Record

This is a spacial node that contains a list of values in a single column table. 

# Basic Syntax

## Record -Name [string] -Row [object[]]

This is the most common way to define a record with a list of values.


    Graph {
        Record -Name Table1 -Rows @(
            'Row1'
            'Row2'
            'Row3'
        )
    } | Show-PSGraph

This will produce a node that looks like this:

![single node record object](/img/record.png)

Under the covers, this is a node object. The command takes care of all the attributes and HTML label formating for you. Because this is a `Node`, you can created edges to it like you would any other node.

    Graph {
        Record -Name Table1 -Rows @(
            'Row1'
            'Row2'
            'Row3'
        )

        Node Other
        Edge Other -To Table1
    }

I offer a lot of flexible ways to work with the `Record` command. Here is the minimal DSL style syntax:

    Graph {
        Record Table1 @(
            'Row1'
            'Row2'
            'Row3'
        )
    }

Just knowing that the 2nd default parameter is an array opens up many options.

    $list = @(
        'Row1'
        'Row2'
        'Row3'
    )

    Record Table1 $list

    $list | Record -Name Table2

## Record -Name [string] -ScriptBlock [ScriptBlock]

Having an array for the second parameter of a PowerShell DSL is not that common. So I also added support for using a `scriptblock`. It works the same as the array in many cases.

    Graph {
        Record Table1 {
            'Row1'
            'Row2'
            'Row3'
        }
    }

We will make better use of that `ScriptBlock` with the `Row` command.

