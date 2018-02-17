
Describe "Function Record" -Tag Build {

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

    It 'simple array example with row script' {
        
        $list = @(
            'first',
            'Second'
        )

        $result = Record test $list {
            Row -Name $PSItem -Label "<B>$PSItem</B>"
        }
        $result | Should -match test
        $result | Should -match 'PORT="first"'        
        $result | Should -match 'PORT="Second"'
        $result | Should -match '<B>first</B>'        
        $result | Should -match '<B>Second</B>'
    } 

    It 'pipeline example' {
        $list = @(
            'first',
            'Second'
        )
        $result = $list | Record test

        $result | Should -match test
        $result | Should -match 'PORT="first"'        
        $result | Should -match 'PORT="Second"'
    }

    It 'pipeline example with row script' {
        $list = @(
            'first',
            'Second'
        )

        $result = $list | Record test -RowScript {
            Row -Name $PSItem -Label "<B>$PSItem</B>"
        }
        $result | Should -match test
        $result | Should -match 'PORT="first"'        
        $result | Should -match 'PORT="Second"'
        $result | Should -match '<B>first</B>'        
        $result | Should -match '<B>Second</B>'
    }
}
