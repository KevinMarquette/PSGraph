# What is PSGraph

I wrote PSGraph to complement [GraphViz](http://graphviz.org/Home.php). Working with GraphViz allowed me to script together directional graphs very easily. The more I worked with it, the more I found myself copy and pasting text around. That is why I finally decided to write some helper functions around it. 

The output from most commands is just text that matches the DOT format specification used by GraphViz. You will notice that all my examples start with a graph specification. This allows me to pipe the results directly into my function that calls GraphViz to generate the final image.

I put a lot of care in writing these command to be easy to use and very flexible, but still be comfortable to anyone that has worked with GraphViz. It should be easy to consult the [GraphViz documentation](http://graphviz.org/Documentation.php) and get any of those advanced features working with this module.  

I can't wait to see the kinds of graphs that people will create now that they can so easily do it from Powershell.