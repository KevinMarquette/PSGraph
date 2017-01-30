# Graph and SubGraph Advanced

Both Graphs and Subgraphs support attributes.

## Graph attributes

You can specify attributes in a `[hashtable]` just like for the `node` and `edge` commands.

    graph g -Attributes @{label='my graph'} {
        edge a,b,c,d,a
    }

Positional attributes also work.

    graph g @{label='my graph'} {
        edge a,b,c,d,aS
    }