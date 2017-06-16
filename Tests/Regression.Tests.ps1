$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

#Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

Describe "Regression tests for Github issues" -Tag Build {

    Context "General problems #3 to #10" {

        It "#3 Problems with inline HTML tagging" {
            $result = node test @{label = "<TABLE><TR><TD><B><U>Node A</U></B></TD></TR></TABLE>"}
            $result | Should be '"test" [label=<<TABLE><TR><TD><B><U>Node A</U></B></TD></TR></TABLE>>;]'
        }

        It "#5 Struct syntax not recognized" {
            edge Struct1:f1 Struct2:f2 | Should be '"STRUCT1":f1->"STRUCT2":f2 '
            edge "Struct 1:f1" "Struct 2:f2" | Should be '"STRUCT 1":f1->"STRUCT 2":f2 '
            
            {$struct = graph g {
                    node @{shape = 'record'}
                    node struct1 @{shape = 'record'; label = " left|<f1> middle|<f2> right"}
                    node struct2 @{shape = 'record'; label = "<f0> one| two"}
                    node struct3 @{shape = 'record'; label = "hello\nworld |{ b |{c|<here> d|e}| f}| g | h"}
                    edge struct1:f1, struct2:f0
                    edge struct1:f2 struct3:here
                } } | Should Not Throw
        }

        It "#10 set edge defaults does not work" {
            edge @{arrowhead = 'none'} | should be 'edge [arrowhead="none";]'
        }

        It "#10 set node defaults does not work" {
            node @{shape = 'house'} | should be 'node [shape="house";]'
        }
    }

    context "#30 Keywords for node names causing parsing errors" {
        $keywordList = @(
            'graph'
            'node'
            'edge'
            'subgraph'
            'rank'
        )

        It "#30 graph (and other keywords) for node name should be in quotes" {
        
            foreach ($keyword in $keywordList)
            {
                $graph = graph g {
                    node $keyword
                }
                $graph | Out-String | Should Match ('"{0}"' -f $keyword)
                $graph | Out-String | Should Not Match ('\s{0}\s' -f $keyword)
            }            
        }
        It "#30 graph (and other keywords) for edges should be in quotes" {
        
            foreach ($keyword in $keywordList)
            {
                $graph = graph g {
                    edge $keyword -to base
                }
                $graph | Out-String | Should Match ('"{0}"' -f $keyword)
                $graph | Out-String | Should Not Match ('\s{0}\s' -f $keyword)
            }            
        }
        It "#30 node default keyword should not be in quotes" {
            
            $graph = graph g {
                node @{label = 'test1'}
            }
            $graph | Out-String | Should Match ' node '                   
        }
        It "#30 edge default keyword should not be in quotes" {
            
            $graph = graph g {
                edge @{label = 'test1'}
            }
            $graph | Out-String | Should Match ' edge '                    
        }
    }

    context "#32 Set-NodeFormatScript applies to node @{shape='rect'} and it should not" {

        AfterEach {
            Set-NodeFormatScript -ScriptBlock {$_}
        }

        It "#32 node default keyword should ignore format scripts" {

            Set-NodeFormatScript -ScriptBlock {"--$_--"}
            $graph = graph g {
                node @{label = 'test1'}
            }
            $graph | Out-String | Should Match ' node '                   
        }
        It "#32 edge default keyword should ignore format scripts" {
            
            Set-NodeFormatScript -ScriptBlock {"--$_--"}
            $graph = graph g {
                edge @{label = 'test1'}
            }
            $graph | Out-String | Should Match ' edge '                    
        }
    }
}