$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

#Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

Describe "Regression tests" -Tag Build {

    Context "Github Issues" {

        It "#3 Problems with inline HTML tagging" {
            $result = node test @{label="<TABLE><TR><TD><B><U>Node A</U></B></TD></TR></TABLE>"}
            $result | Should be 'test [label=<<TABLE><TR><TD><B><U>Node A</U></B></TD></TR></TABLE>>;]'
        }

        It "#5 Struct syntax not recognized" {
            edge Struct1:f1 Struct2:f2 | Should be "STRUCT1:f1->STRUCT2:f2 "
            edge "Struct 1:f1" "Struct 2:f2" | Should be '"STRUCT 1":f1->"STRUCT 2":f2 '
            
            {$struct = graph g {
                node @{shape='record'}
                node struct1 @{shape='record';label=" left|<f1> middle|<f2> right"}
                node struct2 @{shape='record';label="<f0> one| two"}
                node struct3 @{shape='record';label="hello\nworld |{ b |{c|<here> d|e}| f}| g | h"}
                edge struct1:f1,struct2:f0
                edge struct1:f2 struct3:here
            } } | Should Not Throw
        }

        It "#10 set edge defaults does not work" {
            edge @{arrowhead='none'} | should be 'edge [arrowhead=none;]'
        }

        It "#10 set node defaults does not work" {
            node @{shape='house'} | should be 'node [shape=house;]'
        }
    }
}