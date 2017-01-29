# Edge
This is the most useful of all the helper functions in this module. It is used to define a link between two nodes. This function is also very flexible.

# Basic Syntax
## Edge -From [string] To [string]
This is the most common way to define an edge in a graph.

    graph g {
        edge -From start -To middle
        edge -From middle To end
    }

We can shorten this syntax by dropping the `-From` and `-To` properties. 

    graph g {
        edge start middle
        edge middle end
    }

These both generate this basic graph:


[![Source](images/firstGraph.png)](images/firstGraph.png)


## Edge [string[]]
If you have a list of things that connect in order, you can specify the entire list.

    graph g {
        edge start,middle,end
    }

This works even better when you have it defined in an array.

    $list = @('start','middle','end')
    graph g {
        edge $list
    }

## Edge -From [string[]] -To [string[]]
Multiple `from` nodes or `to` nodes can be specified at once. Every node in the `from` list will be connected to every node in the `to` list.

    graph g {
       edge -From web1,web2 -To database1,database2
    }

   
[![Source](images/crossMultiplyEdges.png)](images/crossMultiplyEdges.png)
   

Just like before, you can drop the `-from` or the `-to` keywords if you prefer 