$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

# This one is not tagged with Build because it requires GraphViz
Describe "$ModuleName Export-PSGraph" {

    $dot = graph g {
        node 2 @{shape='house'}
        edge 2,4,8,16
    }

    Context "Basic features" {

        It "Converts file to image" {
            $path = "$testdrive\g.dot"
            Set-Content -Path $path -Value $dot
            Export-PSGraph -SourcePath $path -OutputFormat png

            "$path.png" | Should Exist
        }

        It "Converts file to image over pipe" {
            $path = "$testdrive\g2.dot"
            Set-Content -Path $path -Value $dot
            $path | Export-PSGraph -OutputFormat png

            "$path.png" | Should Exist
        }
    }
}
