# Row -Label [string]

The Row command is used with the `Record` to make a much richer object.

    Graph {
        Record Table1 {
            Row 'Row1'
            Row 'Row2'
            Row 'Row3'
        }
    }

If you take a close look at the `Row` command, it has 3 parameters.

    Row -Label 'MY row' -Name 'Port1' -EncodeHTML

The `-Label` is the text that you see in the record. The `-Lable` is the default parameter when no parameter is specified. The label supports simple HTML.

    Row 'My Row' -Name 'Port1'
    Row -Label 'First: <B>Kevin</B>'

Because the label is rendered as HTML, I added `-EncodeHTML` for when you data includes characters like `<>&` that can mess with the HTML syntax.

    Row -Label 'Mom & Dad' -EncodeHTML

## Row -Label [string] -Name [string]

You can name a row like you name a node. By giving a row a name, we can target it with an edge.

    Graph {
        Record Table1 {
            Row 'Row1' -Name Row1
            Row 'Row2' -Name Row2
            Row 'Row3' -Name Row3
        }

        Record Table2 {
            Row 'Row1' -Name Row1
            Row 'Row2' -Name Row2
            Row 'Row3' -Name Row3
        }

        Edge Table1:Row1 -to Table2:Row1
        Edge Table1:Row3 -to Table2:Row2
    } | Show-PSGraph

![Two nodes with cross edges to rows](/img/recordedge.png)

If the label is a simple word with no spaces or symbols, the row will use that as the default row name. If you start injecting custom HTML into your row, then there will not be a default row name.

The Graphviz documentation refers to those row names as ports on the node.
