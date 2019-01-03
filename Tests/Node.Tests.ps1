Describe 'Function Node' -Tag Build {

    Context "Unit Tests" {

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


    Context "Features" {

        It "Can define multiple nodes at once" {

            {Node (1..5)} | Should Not Throw

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

}
