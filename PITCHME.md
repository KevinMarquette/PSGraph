# PSGraph

PSGraph is a PowerShell module that allows you to script the generation of graphs using the GraphViz engine. It makes it easy to produce data driven visualizations.

---
# Install GraphViz from the Chocolatey repo

    Register-PackageSource -Name Chocolatey -ProviderName Chocolatey -Location http://chocolatey.org/api/v2/
    Find-Package graphviz | Install-Package -ForceBootstrap

# Install PSGraph from the Powershell Gallery

    Find-Module PSGraph | Install-Module

# Import Module

    Import-Module PSGraph

---

# Describe how items are connected

Using a custom DSL, describe how nodes are connected with edges

    Graph "myGraph" {
        Edge start -To middle
        Edge middle -To end
    }

---

# Export and show the Graph

Then we can render the graph as an image.

    Graph "myGraph" {
        Edge -From start -To middle
        Edge -From middle -To end
    }  | Export-PSGraph -ShowGraph

![firstGraph](http://psgraph.readthedocs.io/en/latest/images/firstGraph.png)
