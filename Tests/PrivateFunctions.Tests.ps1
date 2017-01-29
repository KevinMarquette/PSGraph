$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

InModuleScope -ModuleName PSGraph {

    Describe "$ModuleName private functions" {
        
        Context 'Get-LayoutEngine' {

            it "performs basic lookups" {
                $layoutEngine = @{
                    Hierarchical      = 'dot'
                    SpringModelSmall  = 'neato'
                    SpringModelMedium = 'fdp'
                    SpringModelLarge  = 'sfdp'
                    Radial            = 'twopi'
                    Circular          = 'circo'
                }
                foreach($layout in $layoutEngine.GetEnumerator())
                {
                    Get-LayoutEngine -Name $layout.name | Should be $layout.value
                }            
            }
        }

        Context "Get-ArgumentLookUpTable" {

            It "Should not throw an error" {

                {Get-ArgumentLookUpTable} | Should Not Throw
            }

            It "Processes a hashtable" {
                $result = Get-ArgumentLookUpTable
                $result | Should Not BeNullOrEmpty
                $result.gettype().name | Should Be 'Hashtable'        
            }        
        }
    
  
        Context "Get-GraphVizArguments" {
            
            It "Does not throw an error" {
                {Get-GraphVizArguments} | Should Not Throw
            }
            
            It "Should not throw an error with empty hashtable" {
                {Get-GraphVizArguments @{}} | Should Not Throw
            }

            It "Should not throw an error with hashtable" {
                {Get-GraphVizArguments @{OutputFormat='png'}} | Should Not Throw
            }
        }  

        Context "Get-OutputFormatFromPath" {
            
            It "Does not throw an error" {
                {Get-OutputFormatFromPath $null} | Should Not Throw
            }
            It "Can detect a png file" {
                Get-OutputFormatFromPath 'test.png' | Should Be 'png'
            }
            It "Can detect a jpg file" {
                Get-OutputFormatFromPath 'test.jpg' | Should Be 'jpg'
            }
            It "Handles no match correctly" {
                Get-OutputFormatFromPath 'test.notapath' | Should BeNullOrEmpty
            }
        } 

        Context "Get-TranslatedArguments" {
            
            It "Does not throw an error" {
                {Get-TranslatedArguments} | Should Not Throw
            }
            It "Translates DestinationPath" {
                Get-TranslatedArguments @{DestinationPath='test.png'} | Should be '-otest.png'
                Get-TranslatedArguments @{DestinationPath='test.png'} | Should not be '-o test.png'
            }
        }  

        Context "Update-DefaultArguments" {

            It "Does not throw an error" {
                {Update-DefaultArguments @{}} | Should Not Throw
            }
        }
    }

    Describe "$ModuleName ConvertTo-GraphVizAttribute" {

        Context "Basic features" {

            It "Should not throw an error" {

                {ConvertTo-GraphVizAttribute} | Should Not Throw
            }

            It "Creates well formatted attribute" {
                ConvertTo-GraphVizAttribute @{label='test'} | Should Match '\[label="test";\]'
            }

            It "Creates multiple attributes" {
                $result = ConvertTo-GraphVizAttribute @{label='test';arrowsize='2'} 
                
                $result | Should Match '\['
                $result | Should Match 'label="test";'
                $result | Should Match 'arrowsize="2";'                
                $result | Should Match ';\]'
            }

            It "Places graphstyle attributes on multiple lines" {
                $result = ConvertTo-GraphVizAttribute @{label='test';arrowsize='2'} -UseGraphStyle
                $result.count | Should Be 2
            }

            It "Creates scripted attribute on an object" {
                $object = [pscustomobject]@{description='test'}
                ConvertTo-GraphVizAttribute @{label={$_.description}} -InputObject $object | Should Match '\[label="test";\]'
            }

            It "Creates scripted attribute on a hashtable" {
                $object = @{description='test'}
                ConvertTo-GraphVizAttribute @{label={$_.description}} -InputObject $object | Should Match '\[label="test";\]'
            }
        } 
    }
}


