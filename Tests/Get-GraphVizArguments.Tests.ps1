$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

InModuleScope -ModuleName PSGraph {

    Describe "$ModuleName Get-LayoutEngine" {
        
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

    Describe "$ModuleName Get-ArgumentLookUpTable" {

        It "Should not throw an error" {

            {Get-ArgumentLookUpTable} | Should Not Throw
        }

        It "Processes a hashtable" {
            $result = Get-ArgumentLookUpTable
            $result | Should Not BeNullOrEmpty
            $result.gettype().name | Should Be 'Hashtable'        
        }        
    }

    Describe "$ModuleName Get-GraphVizArguments" {

        Context "Basic features" {

            It "Should not throw an error" {

                {Get-GraphVizArguments} | Should Not Throw
            }

            It "Should not throw an error with empty hashtable" {

                {Get-GraphVizArguments @{}} | Should Not Throw

            }
            It "Should not throw an error with hashtable" {

                {Get-GraphVizArguments @{OutputFormat='png'}} | Should Not Throw

            }   
        }

        Context "Test arguments" {
            $arguments = Get-ArgumentLookUpTable

        }
    }
}


