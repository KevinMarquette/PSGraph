Describe 'Function Inline' -Tag Build {
    It 'should not throw' {
        Inline 'INLINE_DOT_TEXT'
    }

    It 'returns inline value' {
        $value = 'INLINE_DOT_TEXT1'
        Inline $value | Should -Be $value
    }

    It 'returns inline value inside a graph' {
        $value = 'INLINE_DOT_TEXT2'
        $rawgraph = graph {
            Inline $value
        }

        ($rawgraph -join "'n") | Should -Match $value
    }
}
