# Installing PSGraph
Make sure you are running Powershell 5.0 (WMF 5.0). I don't know that it is a hard requirement at the moment but I plan on using 5.0 features.

    # Install GraphViz from the Chocolatey repo
    Find-Package graphviz | Install-Package -ForceBootstrap

    # Install PSGraph from the Powershell Gallery
    Find-Module PSGraph | Install-Module 



# Generating your first graph

PSGraph has a unique syntax for defining a graph. This is because it was built specifically for the GraphViz engine. Here is a basic graph to get you started.

    # Import Module
    Import-Module PSGraph

    graph "myGraph" {
        edge start,middle,end        
    } | Export-PSGraph -ShowGraph

This will create a new graph with three nodes linking each other. 

[![Source](images/firstGraph.png)](images/firstGraph.png)

It will save it in the `$env:temp` folder because we did not specify a destination. It will then show the graph when it is done.
