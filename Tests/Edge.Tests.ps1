Describe 'Function Edge' {

    Context "Unit Tests" {

        It "Get-Edge should not throw an error" {

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

    Context "Feature" {

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
}
