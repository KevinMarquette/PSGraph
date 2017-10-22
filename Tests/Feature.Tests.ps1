$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Describe "Basic function feature tests" -Tags Build {

    Context "Graph" {

        It "Graph support attributes" {

            {graph g {} -Attributes @{label = "testcase"; style = 'filled'}} | Should Not Throw

            $resutls = (graph g {} -Attributes @{label = "testcase"; style = 'filled'}) -join ''

            $resutls | Should Match 'label="testcase";'
            $resutls | Should Match 'style="filled";'
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

    Context "SubGraph" {
        It "Items can be placed in a subgraph" {
            {
                graph test {
                    subgraph 0 {
                        node helo
                        edge hello world
                        rank same level
                        subgraph 1 {

                        }
                    }
                }
            } | Should Not Throw
        }
    }

    Context "Node" {

        It "Can define multiple nodes at once" {

            {node (1..5)} | Should Not Throw

            $result = Node (1..5)
            $result | Should not Be NullOrEmpty
            $result.count | Should be 5
            $result[0] | Should match '1'
            $result[4] | Should match '5'

            {node one, two, three, four} | Should Not Throw
            {node @(Write-Output one two three four)} | Should Not Throw
        }

        It "Supports Node scriptblocks" {
            $object = @{name = 'mName'}
            node $object -NodeScript {$_.name}
        }

        It "Supports node scriptblocks and attribute scriptblocks" {
            $object = @{name = 'mName'; shape = 'rectangle'}
            node $object -NodeScript {$_.name} @{shape = {$_.shape}}
        }

        It "Supports -ranked swtich with multiple nodes #43" {
            $testNode = 'Test123'
            $result = Node one, two, $testNode -Ranked
            $result | Out-String | Should match 'rank'
            ($result -match $testNode).count | Should Be 2
        }

        It "-ranked with one node should not create a rank #43" {
            $testNode = 'Test456'
            $result = Node $testNode
            $result | Out-String | Should not match 'rank'
            ($result -match $testNode).count | Should Be 1
        }
    }

    Context "Edge" {

        It "Can define multiple edges at once in a chain" {
            {edge one, two, three} | Should Not Throw

            $result = Edge one, two, three
            $result | Should Not BeNullOrEmpty
            $result.count | Should be 2
            $result[0] | Should match '"one"->"two"'
            $result[1] | Should match '"two"->"three"'
        }

        It "Can define multiple edges at once, with cross multiply" {
            {Edge one, two three, four} | Should Not Throw

            $result = Edge one, two three, four
            $result | Should Not BeNullOrEmpty
            $result.count | Should be 4
            $result[0] | Should match '"one"->"three"'
            $result[1] | Should match '"one"->"four"'
            $result[2] | Should match '"two"->"three"'
            $result[3] | Should match '"two"->"four"'
        }
    }

    Context "Rank" {

        It "Can rank an array of items" {

            {rank (1..3)} | Should Not Throw

            $result = rank (1..3)
            $result | Should Not BeNullOrEmpty
            $result.count | Should be 1
            $result | should match '{ rank=same;  "1"; "2"; "3"; }'
        }

        It "Can rank a list of items" {

            {rank one two three} | Should Not Throw

            $result = rank one two three
            $result | Should Not BeNullOrEmpty
            $result.count | Should be 1
            $result | should match '{ rank=same;  "one"; "two"; "three"; }'
        }

        it "Can rank objects with a script block" {
            $objects = @(
                @{name = 'one'}
                @{name = 'two'}
                @{name = 'three'}
            )

            {rank $objects -NodeScript {$_.name}} | Should Not Throw
        }
    }

    Context "Indentation" {

        It "Has no indention for first graph element" {
            $result = graph g {node test}
            $result | Where-Object {$_ -match 'digraph'} | Should Match '^digraph'
        }

        It "Has 4 space indention for first level items" {
            $result = graph g {
                node testNode
                edge testEdge1 testEdge2
                rank testRank
            }
            $result | Where-Object {$_ -match 'testNode'}  | Should Match '^    "testNode"'
            $result | Where-Object {$_ -match 'testEdge1'} | Should Match '^    "testEdge1"'
            $result | Where-Object {$_ -match 'rank'}  | Should Match '^    { rank'
        }

        It "Has 4 space indention for first subbraph" {
            $result = graph g {
                subgraph 0 {
                    node test
                }
            }
            $result | Where-Object {$_ -match 'subgraph'} | Should Match '^    subgraph'
        }

        It "Has 8 space indention for nested items" {
            $result = graph g {
                subgraph 0 {
                    node testNode
                    edge testEdge1 testEdge2
                    rank testRank
                }
            }
            $result | Where-Object {$_ -match 'testNode'}  | Should Match '^        "testNode"'
            $result | Where-Object {$_ -match 'testEdge1'} | Should Match '^        "testEdge1"'
            $result | Where-Object {$_ -match 'rank'}  | Should Match '^        { rank'
        }

        It "Has 12 space indention for nested items" {
            $result = graph g {
                subgraph 0 {
                    subgraph 1 {
                        node testNode
                        edge testEdge1 testEdge2
                        rank testRank
                    }
                }
            }
            $result | Where-Object {$_ -match 'testNode'}  | Should Match '^            "testNode"'
            $result | Where-Object {$_ -match 'testEdge1'} | Should Match '^            "testEdge1"'
            $result | Where-Object {$_ -match 'rank'}  | Should Match '^            { rank'
        }
    }
}
