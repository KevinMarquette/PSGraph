$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Describe "Function Record" {

    It 'does not throw' {
        Record Test {} | Should -Not -BeNullOrEmpty
    }

    It 'simple script example' {
        $result = Record test {
            'first'
            'second'
        } 
        $result | Should -match test
        $result | Should -match 'PORT="first"'        
        $result | Should -match 'PORT="Second"'
    } 

    It 'script example with row' {
        $result = Record test {
            Row 'first'
            'second'
        } 
        $result | Should -match test
        $result | Should -match 'PORT="first"'        
        $result | Should -match 'PORT="Second"'
    } 

    It 'simple array example' {
        $result = Record test @(
            'first'
            'second'
        ) 
        $result | Should -match test
        $result | Should -match 'PORT="first"'        
        $result | Should -match 'PORT="Second"'
    } 
}
