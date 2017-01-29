# Edge Advanced
The command has several advanced features built into it.

## Edge Attributes
According to the DOT specification, you can supply several attibutes that modify the edge. The most common one is giving it a label.

    graph g {
        edge here there -Attributes @{label='to'}
    }

    graph g {
        edge here there @{label='to'}
    }


[![Source](images/hereToThere.png)](images/hereToThere.png)

You will have to check out the [GraphViz Dot Language reference](http://graphviz.org/content/attrs) for all the possible attributes. I don't yet validate any of them

The edge command also supports a literal attributes argument in case you would prefer it.

    graph g {
        edge here there -LiteralAttribute '[label="to";]'
    }

## Object and scripted node specification
This is one really advanced but super powerful features of the edge command. You can specify an input object and then provide script blocks for it to use values off of the object for the `from` and `to` nodes.

Let's assume we have a `$csv` that contains a boss and employee field. We could script it like this:

    graph g {
        $csv | %{edge $_.boss -to $_.employee}
    }

or like this:

    graph g {
        @($csv).ForEach({edge $_.boss -to $_.employee})
    }

But the edge command has aditional support for processing objects and allows you to create it this way:

    graph g{
        edge $csv -FromScript {$_.boss} -ToScript {$_.employee}
    }

This will walk each object and pull those values off of it. The cool thing is that you can run any powershell in those script blocks. You can do API calls or hashtable lookups.

Here is one last example:

    $folder = Get-ChildItem -recurse -directory
    graph g {
        edge $folder -FromScript {$_.parent} -ToScript {$_.name}
    }

## Scripted Attributes
I am not exactly sure if this feature will get wide spread use, but I also support using script blocks in the attribute hashtables.

    $folder = Get-ChildItem -recurse -directory
    graph g {
        edge $folder -FromScript {$_.parent} -ToScript {$_.name} @{label={$_.fullname}}
    }

I was thinking you could add logic in there to change the shape, color or label based on the object.
