[![Build status](https://ci.appveyor.com/api/projects/status/cgo827o4f74lmf9w/branch/master?svg=true)](https://ci.appveyor.com/project/kevinmarquette/PSGraphViz/branch/master) 

# PSGraphViz

PSGraphViz is a helper module for generating GraphViz graphs. The goal is to make it easier to generate graphs using Powershell. 

## What is GraphViz?

[Graphviz](http://graphviz.org/) is open source graph visualization software. Graph visualization is a way of representing structural information as diagrams of abstract graphs and networks. It has important applications in networking, bioinformatics,  software engineering, database and web design, machine learning, and in visual interfaces for other technical domains. 

## Project status?
Experimental. I am still flashing out ideas on how I want to approach parts of module. Consider it unstable and highly likely to change quite a bit. 

# GraphViz and the Dot format basics
The nice thing about GraphViz is that you can define nodes and edges with a simple text file in the Dot format. The GraphViz engine handles the layout, edge routing, rendering and creates an image for you. 

Here is a sample Dot file.

    digraph g {
        "Start"->"Middle"
        "Middle"->"End"
    }

This will produce a graph with 3 nodes with the names `Start`, `Middle` and `End`. There will be an edge line connecting them in order. Go checkout the [GraphViz Gallery](http://graphviz.org/Gallery.php) to see some examples of what you can do with it.

## How PSGraphViz can help
we can create those Dot files with PSGraphViz in Powershell. Here is that same graph as above.

    digraph g {
        edge Start Middle
        edge Middle End
    }

Here is a second way to approach it now.

    $objects = @("Start","Middle","End")
    digraph g {
        edge $objects
    }

 The real value here is that I can specify a collection to process. This allows the graph to be data driven.

# PSGraphViz Commands
I tried to keep a syntax that was similar to GraphViz but offer the flexibility of Powershell. If you have worked with GraphViz before, then you should feel right at home.

## Graph or digraph
This is the container that holds graph elements. Every valid GraphViz graph has one. `digraph` is just an alias of `graph` so I am going to use the shorter `graph` for the rest of the readme.

    graph g {        
    }

## Edge
This defines an edge or connection between nodes. This command accepts a list of strings or an array of strings. It will connect them all in sequence. This should be placed inside a `graph` or `subgraph`.

    graph g {
        edge one two three four
        edge (1..5)
    }

If you supply two arrays, it will cross multiply them. So each item on the left with have a path to each item on the right.

    graph g {
        edge (1,3) (2,4)
    }
    
Because this is Powershell, we can mix in normal commands. Take this example.

    $folders = Get-ChildItem -Directory -Recurse
    graph g {
        $folders | %{edge $_.Name $_.Parent} 
    }

I also support edge attributes that are defined in the DOT specification by using a hashtable.

   graph g {
       edge "Point One" "Point Two" @{label='A line'}
   }

## Node
The Node command allows you to introduce a node on the graph before an edge is created. This is used to give specific nodes different attributes or to place them in subgraphs. The node command will also accept an array of values and a hashtable of attributes.

    graph g {
        node start @{shape='house'}
        node end @{shape='invhouse'}
        edge start,middle,end
    }

This is the exact Dot output generated those node commands.

    digraph g {

        "start" [shape="house"]
        "end" [shape="invhouse"]
        "start"->"middle" 
        "middle"->"end" 
    }

# Installing PSGraphViz
Make sure you are running Powershell 5.0 (WMF 5.0). I don't know that it is a hard requirement at the moment but I plan on using 5.0 features.

    # Install GraphViz from the Chocolatey repo
    Find-Package graphviz | Install-Package -ForceBootstrap

    # Install PSGraphViz from the Powershell Gallery
    Find-Module PSGraphViz | Install-Module 

    # Import Module
    Import-Module PSGraphViz

# Generating a graph image
I am still working out the workflow for this, but for now just do this.

    # Create graph in variable
    $dot = graph g {
        edge hello world
    }

    # Save to file
    Set-Content -Path $env:temp\hello.vz -Value $dot
    
    # Generate Graph
    Invoke-PSGraphViz -Path $env:temp\hello.vz -OutputFormat png
    Start $env:temp\hello.vz.png

I'll come back and clean this up.