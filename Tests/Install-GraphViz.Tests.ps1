InModuleScope -ModuleName PSGraph {
    Describe 'Function Install-GraphViz' -Tag Build {

        Mock -Verifiable Get-PackageProvider {}
        Mock -Verifiable Register-PackageSource {}
        Mock -Verifiable Find-Package {}
        Mock -Verifiable Install-Package {}

        It 'Should not throw' {
            Install-GraphViz -WhatIf
        }
    }
}
