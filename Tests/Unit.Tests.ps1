$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

Describe "Basic function unit tests" {

    Context "Graph" {

        it "Graph should not throw an error" {

            {Graph g {}} | Should Not Throw
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

        it "Builds basic graph" {
            $result = (SubGraph 0 {}) -join ''

            $result | Should Not BeNullOrEmpty
            $result | Should match 'cluster_0'
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

            {Node TestNode @{shape='rectangle'}} | Should Not Throw
        }

        It "Creates a simple node" {
            Node TestNode | Should Match '"TestNode"'
        }

        It "Creates a node with attributes" {
            Node TestNode @{shape='rectangle'} | Should Match '"TestNode" \[shape="rectangle"\]'
            Node TestNode @{shape='rectangle';label="myTest"} | Should Match '"TestNode" \[shape="rectangle";label="myTest"\]'
        }
    }

    Context "Edge" {
        it "Get-Edge should not throw an error" {

            {Edge lhs rhs } | Should Not Throw
        }

        it "Edge alias should not throw an error" {

            {Edge lhs rhs} | Should Not Throw
        }

        it "Edge attributes should not throw an error" {

            {Edge lhs rhs @{label='test'}} | Should Not Throw
        }

        It "Creates a simple Edge" {
            Edge lhs rhs | Should Match '"lhs"->"rhs"'
        }

        It "Creates a Edge with attributes" {
            Edge lhs rhs @{label='test'} | Should Match '"lhs"->"rhs" \[label="test"\]'
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
            rank lhs rhs | Should Match '{ rank=same;  "lhs" "rhs"; }'
        }
    }
}