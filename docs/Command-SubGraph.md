# SubGraph

This allows you to define a graph within the graph. This will group those objects together in some engines.

     graph g {
        subgraph 0 {
            web1,web2,reports
            edge report -To web1,web2
        }        
        edge loadBalancer -To web1,web2
        edge user -To loadBalancer,reports
        edge web1,web2,reports -To database
    }


[![Source](images/subGraph.png)](images/subGraph.png)
   