$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

#Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

InModuleScope -ModuleName PSGraph {

    Describe "$ModuleName private functions" -Tag Build {

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
                foreach ($layout in $layoutEngine.GetEnumerator())
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


        Context "Get-GraphVizArgument" {

            It "Does not throw an error" {
                {Get-GraphVizArgument} | Should Not Throw
            }

            It "Should not throw an error with empty hashtable" {
                {Get-GraphVizArgument @{}} | Should Not Throw
            }

            It "Should not throw an error with hashtable" {
                {Get-GraphVizArgument @{OutputFormat = 'png'}} | Should Not Throw
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
                {Get-TranslatedArgument} | Should Not Throw
            }
            It "Translates DestinationPath" {
                Get-TranslatedArgument @{DestinationPath = 'test.png'} | Should be '-otest.png'
                Get-TranslatedArgument @{DestinationPath = 'test.png'} | Should not be '-o test.png'
            }
        }

        Context "Update-DefaultArgument" {

            It "Does not throw an error" {
                {Update-DefaultArgument @{}} | Should Not Throw
            }
        }

        Context "Format-Value" {

            BeforeEach {
                Set-NodeFormatScript -ScriptBlock {$_}
            }

            It "not throw an error" {
                {Format-Value test} | Should Not Throw
            }

            It "not throw an error for edges" {
                {Format-Value test -edge} | Should Not Throw
            }

            It "not throw an error for node" {
                {Format-Value test -edge} | Should Not Throw
            }

            It "format basic strings with quotes" {
                Format-Value test | Should Be '"test"'
                Format-Value test -node | Should Be '"test"'
                Format-Value test -edge | Should Be '"test"'
            }

            It "format basic strings with spaces in quotes" {
                Format-Value 'test value' | Should Be '"test value"'
                Format-Value 'test value' -node | Should Be '"test value"'
                Format-Value 'test value' -edge | Should Be '"test value"'
            }

            It "format basic strings with a colin correctly" {
                Format-Value 'test:value' | Should Be '"test:value"'
                Format-Value 'test:value' -node | Should Be '"test:value"'
                Format-Value 'test:value' -edge | Should Be '"test":value'
                Format-Value 'test value2:value' -edge | Should Be '"test value2":value'
            }

            It "Uses custom format script correctly" {
                Set-NodeFormatScript -ScriptBlock {'NewValue'}
                Format-Value 'test' | Should BeExactly '"test"'
                Format-Value 'test' -node | Should BeExactly '"NewValue"'
                Format-Value 'test' -edge | Should BeExactly '"NewValue"'

                Set-NodeFormatScript -ScriptBlock {$_.ToUpper()}
                Format-Value 'test' | Should BeExactly '"test"'
                Format-Value 'test' -node | Should BeExactly '"TEST"'
                Format-Value 'test' -edge | Should BeExactly '"TEST"'
                Format-Value 'test' | Should Not BeExactly '"TEST"'
                Format-Value 'test' -node | Should Not BeExactly '"test"'
                Format-Value 'test' -edge | Should Not BeExactly '"test"'
                Set-NodeFormatScript
            }

        }

        Context "ConvertTo-GraphVizAttribute" {

            It "Should not throw an error" {

                {ConvertTo-GraphVizAttribute} | Should Not Throw
            }

            It "Creates well formatted attribute" {
                ConvertTo-GraphVizAttribute @{label = 'test'} | Should Match '\[label="test";\]'
            }

            It "Creates well formatted attribute with special characters" {
                ConvertTo-GraphVizAttribute @{label = 'test label'} | Should Match '\[label="test label";\]'
            }

            It "Creates well formatted attribute for html tables" {
                ConvertTo-GraphVizAttribute @{label = '<table>test label</table>'} | Should Match '\[label=<<table>test label</table>>;\]'
            }

            It "Creates multiple attributes" {
                $result = ConvertTo-GraphVizAttribute @{label = 'test'; arrowsize = '2'}

                $result | Should Match '\['
                $result | Should Match 'label="test";'
                $result | Should Match 'arrowsize="2";'
                $result | Should Match ';\]'
            }

            It "Places graphstyle attributes on multiple lines" {
                $result = ConvertTo-GraphVizAttribute @{label = 'test'; arrowsize = '2'} -UseGraphStyle
                $result.count | Should Be 2
            }

            It "Creates scripted attribute on an object" {
                $object = [pscustomobject]@{description = 'test'}
                ConvertTo-GraphVizAttribute @{label = {$_.description}} -InputObject $object | Should Match '\[label="test";\]'
            }

            It "Creates scripted attribute on a hashtable" {
                $object = @{description = 'test'}
                ConvertTo-GraphVizAttribute @{label = {$_.description}} -InputObject $object | Should Match '\[label="test";\]'
            }
        }
    }
}
