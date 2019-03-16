InModuleScope PSGraph {

    Describe 'Function Set-NodeFormatScript' -Tag Build {

        BeforeEach {
            Set-NodeFormatScript
        }

        AfterAll {
            Set-NodeFormatScript
        }

        It "Uses custom format script correctly" {
            Set-NodeFormatScript -ScriptBlock {'NewValue'}
            Format-Value 'test' | Should BeExactly '"test"'
            Format-Value 'test' -node | Should BeExactly '"NewValue"'
            Format-Value 'test' -edge | Should BeExactly '"NewValue"'
        }

        It 'Handles $PSItem in scriptblock' {
            Set-NodeFormatScript -ScriptBlock {$_.ToUpper()}
            Format-Value 'test' | Should BeExactly '"test"'
            Format-Value 'test' -node | Should BeExactly '"TEST"'
            Format-Value 'test' -edge | Should BeExactly '"TEST"'
            Format-Value 'test' | Should Not BeExactly '"TEST"'
            Format-Value 'test' -node | Should Not BeExactly '"test"'
            Format-Value 'test' -edge | Should Not BeExactly '"test"'
        }
    }
}
