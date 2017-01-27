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

    Describe "$ModuleName Get-GraphVizArguments" {

        Context "Basic features" {

            It "Should not throw an error" {

                {Get-GraphVizArguments} | Should Not Throw
            }

           
        }

        Context "Test arguments" {
            $arguments = Get-ArgumentLookUpTable

        }
    }
}


