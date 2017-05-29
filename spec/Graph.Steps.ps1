then " Graph unit tests will all pass" {

    it "Graph should not throw an error" {

        {Graph g {}} | Should Not Throw
    }

    it "Graph attributes should not throw an error" {

        {Graph g -Attributes @{label='test'} {}} | Should Not Throw
    }

    it "Graph positional attributes should not throw an error" {

        {Graph g @{label='test'} {}} | Should Not Throw
    }

    it "Builds basic graph" {

        $name = 'GRAPH_NAME'
        $result = (Graph $name {}) -join ''

        $result | Should Not BeNullOrEmpty
        $result | Should match $name
        $result | Should match '{'
        $result | Should match '}'
        $result | Should match 'digraph'
    }
}

Then  "Graph feature tests will all pass" {
        
    It "Graph support attributes" {

        {graph g {} -Attributes @{label="testcase";style='filled'}} | Should Not Throw
        
        $resutls = (graph g {} -Attributes @{label="testcase";style='filled'}) -join ''

        $resutls | Should Match 'label=testcase;'
        $resutls | Should Match 'style=filled;'
    }

    It "Items can be placed in a graph" {
        {
            graph test {
                node helo
                edge hello world
                rank same level
                subgraph 0 {

                }
            }
        } | Should Not Throw
    }
}