Describe 'Function Entity' -Tag Build {

    BeforeAll {
        $Object = [PSCustomObject]@{
            FirstName = 'FIRST_NAME'
            LastName = 'LAST_NAME'
            Age = 37
        }
    }

    It 'Default view shows types' {

        $raw = Entity $object
        $raw | Should -Match 'FirstName'
        $raw | Should -Match 'LastName'
        $raw | Should -Match '\[String\]'
        $raw | Should -Match 'PSCustomObject'
        $raw | Should -Not -Match 'LAST_NAME'
        $raw | Should -Not -Match 'FIRST_NAME'
    }

    It 'Name Parameter' {
        $CustomName = 'CUSTOM_NAME'
        $raw = Entity $object -Name $CustomName
        $raw | Should -Match $CustomName
        $raw | Should -Not -Match 'PSCustomObject'
    }

    Context "Show Parameter" {

        It '[TypeName] shows types' {

            $raw = Entity $object -Show TypeName
            $raw | Should -Match 'FirstName'
            $raw | Should -Match 'LastName'
            $raw | Should -Match '\[String\]'
            $raw | Should -Not -Match 'LAST_NAME'
            $raw | Should -Not -Match 'FIRST_NAME'
        }

        It '[Value] shows values' {

            $raw = Entity $object -Show Value
            $raw | Should -Match 'FirstName'
            $raw | Should -Match 'LastName'
            $raw | Should -Match 'LAST_NAME'
            $raw | Should -Match 'FIRST_NAME'
            $raw | Should -Not -Match '\[String\]'
        }

        It '[Name] shows only the name' {

            $raw = Entity $object -Show Name
            $raw | Should -Match 'FirstName'
            $raw | Should -Match 'LastName'
            $raw | Should -Not -Match 'LAST_NAME'
            $raw | Should -Not -Match 'FIRST_NAME'
            $raw | Should -Not -Match '\[String\]'
        }
    }
}
