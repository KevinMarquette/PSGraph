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

### Example: Server farm data

Imagine you wanted to diagram a server farm.

I'm generating example servers here:

    # Server counts
    $WebServerCount = 2
    $APIServerCount = 2
    $DatabaseServerCount = 2

    # Server lists
    $WebServer = 1..$WebServerCount | % {"Web_$_"}
    $APIServer = 1..$APIServerCount | % {"API_$_"}
    $DatabaseServer = 1..$DatabaseServerCount | % {"DB_$_"}

But you could source these from AD or your CMDB

---

### Example: Server farm graph

Then describe how those lists of servers relate to each other

    graph servers {
        node -Default @{shape='box'}
        edge LoadBalancer -To $WebServer
        edge $WebServer -To $APIServer
        edge $APIServer -To AvailabilityGroup
        edge AvailabilityGroup -To $DatabaseServer
    } | Export-PSGraph -ShowGraph 

---

### Example: Server farm graph image

![servers](https://kevinmarquette.github.io/img/servers.png)

---

### Project structures

![files structure](http://psgraph.readthedocs.io/en/latest/images/filesSmall.png)

---

### Parent and child processes

![related processes](http://psgraph.readthedocs.io/en/latest/images/processSmall.png)

---

### Network connections

![network connections](http://psgraph.readthedocs.io/en/latest/images/networkConnection.png)

---

### What will you graph?

For more information

* [psgraph.readthedocs.io](http://psgraph.readthedocs.io)
* [github.com/kevinmarquette/psgraph](https://github.com/kevinmarquette/psgraph)
* [kevinmarquette.github.io](https://kevinmarquette.github.io)