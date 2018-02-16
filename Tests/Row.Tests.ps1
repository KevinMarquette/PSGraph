$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Describe "Function Row" {

    It 'does not throw' {
        Row Test | Should -Not -BeNullOrEmpty
    }

    It 'returns a HTML row unmodified' {
        $text = '<TR>stuff</TR>'
        Row $text | Should -Be $text
    }

    It 'uses simple label as port id' {
        Row Test | Should -Match 'PORT="Test"'
    }

    It 'does not use complex label as port id' {
        Row 'Test<b>test</b>' | Should -Not -Match 'PORT="Test'
    }

    It 'should use specified ID as port' {
        Row Label -ID Test | Should -Match 'PORT="Test"'
        Row Label -Name Test | Should -Match 'PORT="Test"'
    }
}
