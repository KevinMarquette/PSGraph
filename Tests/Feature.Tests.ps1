$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force


Describe "Basic function feature tests" {

    Context "Graph" {
        
        It "Graph support attributes" {
            {graph g {} -Attributes @{label="testcase";style='filled'}} | Should Not Throw
            
            $resutls = (graph g {} -Attributes @{label="testcase";style='filled'}) -join ''

            $resutls | Should Match 'label="testcase";'
            $resutls | Should Match 'style="filled";'
        }
    }
}
