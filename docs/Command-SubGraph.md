# SubGraph

This allows you to define a graph within the graph. This will group those objects together in some engines.

     graph {
        subgraph -Attributes @{label='DMZ'} {
            node web1,web2,reports
            edge report -To web1,web2
        }        
        edge loadBalancer -To web1,web2
        edge user -To loadBalancer,report
        edge web1,web2,report -To database
    }


[![Source](images/subGraph.png)](images/subGraph.png)
