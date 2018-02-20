# Graph [string] [scriptblock]
This is the base command that defines a graph. 

    graph "myGraph" {
        edge start,middle,end        
    }

The basic syntax is `Graph [String] [Scriptblock]`. The output of this command is a `[string[]]` containing a graph definition in the GraphViz DOT language. 

This is the output from the command above:

    digraph myGraph {
        "start"->"middle" 
        "middle"->"end" 
    }

In this simple example, there is not much difference. Most simple graphs could easily be crafted by hand using the native DOT syntax. The goal of this module is to make the more complicated or scripted graphs easier to work with.

Knowing that the `graph` command gives us a `[string[]]` will allow us to do two different things.

## Save a graph to a variable

The most basic thing we can do is just save it to a variable.

    $firstGraph = graph "myGraph" {
        edge start,middle,end        
    }

Once you have it in that variable, we can save it to a file. 

    Set-Content -Path $path -Value $firstGraph

If you are already comfortable working with GraphViz, you can have it process this `$path` file directly. Or you can use my helper function `Export-PSGraph -Source $file` to generate the final image.

## Pipe to Export-Path

The other thing we can do is pipe it directly to the export function to get our image.

    graph "myGraph" {
        edge start,middle,end        
    } Export-PSGraph -DestinationPath $path

## Creative use of scriptblocks
Don't forget that the body of the graph is a Powershell script block. You can use regular Powershell inside it if you need to.

    graph myGraph {
        $csv | %{edge -from $_.boss -to $_.employee}
    }

# Graph and SubGraph Advanced

Both Graphs and Subgraphs support attributes.

## Graph [string] -Attributes [hashtable] [scriptblock]

You can specify attributes in a `[hashtable]` just like for the `node` and `edge` commands.

    graph g -Attributes @{label='my graph'} {
        edge a,b,c,d,a
    }

Positional attributes also work.

    graph g @{label='my graph'} {
        edge a,b,c,d,aS
    }