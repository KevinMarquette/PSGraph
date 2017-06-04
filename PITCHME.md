# PSGraph

PSGraph is a PowerShell module that allows you to script the generation of graphs using the GraphViz engine. It makes it easy to produce data driven visualizations.

---
### Install GraphViz from the Chocolatey repo

    Register-PackageSource -Name Chocolatey -ProviderName Chocolatey -Location http://chocolatey.org/api/v2/
    Find-Package graphviz | Install-Package -ForceBootstrap

### Install PSGraph from the Powershell Gallery

    Find-Module PSGraph | Install-Module

### Import Module

    Import-Module PSGraph

---

### Describe how items are connected

Using a custom DSL, describe how nodes are connected with edges

    Graph "myGraph" {
        Edge start -To middle
        Edge middle -To end
    }

---

### Export and show the Graph

Then we can render the graph as an image.

    Graph "myGraph" {
        Edge -From start -To middle
        Edge -From middle -To end
    }  | Export-PSGraph -ShowGraph


![firstGraph](http://psgraph.readthedocs.io/en/latest/images/firstGraph.png)

---

### Data driven graphs

The real fun starts when you generate data driven graphs.

---

### Example: Server Farm data

Imagine you wanted to diagram a server farm dynamically.

    # Server counts
    $WebServerCount = 2
    $APIServerCount = 2
    $DatabaseServerCount = 2

    # Server lists
    $WebServer = 1..$WebServerCount | % {"Web_$_"}
    $APIServer = 1..$APIServerCount | % {"API_$_"}
    $DatabaseServer = 1..$DatabaseServerCount | % {"DB_$_"}

---

### Example: Server Farm graph

    graph servers {
        node -Default @{shape='box'}
        edge LoadBalancer -To $WebServer
        edge $WebServer -To $APIServer
        edge $APIServer -To AvailabilityGroup
        edge AvailabilityGroup -To $DatabaseServer
    } | Export-PSGraph -ShowGraph 

![servers](https://kevinmarquette.github.io/img/servers.png)