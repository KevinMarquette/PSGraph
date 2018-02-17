$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

#Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

Describe "Basic function unit tests" -Tags Build {

    Context "Graph" {

        it "Graph should not throw an error" {

            {Graph g {}} | Should Not Throw
        }

        it "Graph without name should not throw an error #41" {
            
            {Graph {}} | Should Not Throw
        }

        it "Graph attributes should not throw an error" {

            {Graph g -Attributes @{label = 'test'} {}} | Should Not Throw
        }

        it "Graph positional attributes should not throw an error" {

            {Graph g @{label = 'test'} {}} | Should Not Throw
        }

        it "Graph without name positional attributes should not throw an error #41" {
            
            {Graph @{label = 'test'} {}} | Should Not Throw
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

    Context "SubGraph" {

        it "SubGraph alias should not throw an error" {

            {SubGraph 0 {}} | Should Not Throw
        }

        it "SubGraph attributes should not throw an error" {

            {SubGraph 0 -Attributes @{label = 'test'} {}} | Should Not Throw
        }

        it "SubGraph positional attributes should not throw an error" {

            {SubGraph 0 @{label = 'test'} {}} | Should Not Throw
        }

        it "Builds basic graph" {
            $result = (SubGraph 0 {}) -join ''

            $result | Should Not BeNullOrEmpty
            $result | Should match 'cluster0'
            $result | Should match '{'
            $result | Should match '}'
            $result | Should match 'subgraph'
        }
    }

    Context "Node" {

        it "Node alias should not throw an error" {

            {Node TestNode } | Should Not Throw
        }

        it "Node attributes should not throw an error" {

            {Node TestNode @{shape = 'rectangle'}} | Should Not Throw
        }

        It "Creates a simple node" {
            Node TestNode | Should Match 'TestNode'
        }

        It "Creates a node with attributes" {
            Node TestNode @{shape = 'rectangle'} | Should Match '"TestNode" \[shape="rectangle";\]'
            $result = Node TestNode @{shape = 'rectangle'; label = "myTest"} 
            $result | Should Match '"TestNode" \[.*=".*";.*=".*";\]'
            $result | Should Match 'shape="rectangle";'
            $result | Should Match 'label="myTest";'
        }
    }

    Context "Edge" {
        it "Get-Edge should not throw an error" {

            {Edge lhs rhs } | Should Not Throw
        }

        It "Edge alias should not throw an error" {

            {Edge lhs rhs} | Should Not Throw
        }

        It "Edge attributes should not throw an error" {

            {Edge lhs rhs @{label = 'test'}} | Should Not Throw
        }

        It "Creates a simple Edge" {
            Edge lhs rhs | Should Match '"lhs"->"rhs"'
        }

        It "Creates a Edge with attributes" {
            Edge lhs rhs @{label = 'test'} | Should Match '"lhs"->"rhs" \[label="test";\]'
        }

        It "Creates a Edge with multiple attributes" {
            $result = Edge lhs rhs @{label = 'test'; arrowsize = '2'}

            $result | Should Match 'label="test";'
            $result | Should Match 'arrowsize="2";'
        }

        It "Creates an edge with scripted properties" {
            $object = @{source = 'here'; target = 'there'}
            $result = edge $object -FromScript {$_.source} -ToScript {$_.target}
            $result | Should Match '"here"->"there"'
        }

        It "Creates an edge with scripted properties and attributes" {
            $object = @{source = 'here'; target = 'there'; description = 'to'}
            $result = edge $object -FromScript {$_.source} -ToScript {$_.target} -Attributes @{label = {$_.description}}
            $result | Should Match '"here"->"there" \[label="to";\]'
        }

        It "Creates multiple edges with scripted properties and attributes" {
            $object = @(
                @{source = 'here'; target = 'there'; description = 'to'}
                @{source = 'LA'; target = 'NY'; description = 'roadtrip'}
            )
            $result = edge $object -FromScript {$_.source} -ToScript {$_.target} -Attributes @{label = {$_.description}}
            $result[0] | Should Match '"here"->"there" \[label="to";\]'
            $result[1] | Should Match '"LA"->"NY" \[label="roadtrip";\]'
        }
    }

    Context "Rank" {
        it "Get-Rank should not throw an error" {

            {Rank lhs rhs } | Should Not Throw
        }

        it "Rank alias should not throw an error" {

            {Rank lhs rhs} | Should Not Throw
        }

        It "Creates a rank grouping" {
            rank lhs rhs | Should Match '{ rank=same;  "lhs"; "rhs"; }'
        }
    }
}