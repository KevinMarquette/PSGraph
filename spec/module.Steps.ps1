<#BeforeEachFeature {
    $Script:ModuleName = $null
    $Script:ModuleRoot = $null
    $Script:BaseFolder = $null
}#>

Given 'the module was named (\S*)' {
    Param($Name)
    $Script:ModuleName = $Name
}

Given 'it had a psm1 file' {
    $path = "$PSScriptRoot\.."
    $ModuleName | should be 'PSGraph'
    $module = Get-ChildItem -Path $path -Recurse -Filter "$ModuleName.psm1" -verbose
    $module | should not benullorempty
    $module.fullname | Should Exist

    $Script:ModuleRoot = Split-Path $module.fullname
}

Given 'the (\S*) root folder' {
    Param($root)
    Switch($root)
    {
        'Project'
        {
            $script:BaseFolder = Resolve-Path "$PSScriptRoot\.." | Select -ExpandProperty Path
        }
        'Module'
        {
            $script:BaseFolder = $Script:ModuleRoot
        }
    }
}

Then 'it (will have|had) a (?<Path>\S*) (file|folder).*' {
    Param($Path)

    Join-Path $script:BaseFolder $Path | Should Exist
}

When 'the module is imported' {
    { Import-Module $ModuleRoot } | Should Not Throw
}

Then 'Get-Module will show the module' {
    Get-Module -Name $ModuleName | Should Not BeNullOrEmpty
}

Then 'Get-Command will list functions' {
    Get-Command -Module $ModuleName | Should Not BeNullOrEmpty
}

Then '(?<Function>\S*) will have comment based help' {
    Param($Function)
    $help = Get-Help $Function
    $help | Should Not BeNullOrEmpty
}

Then 'all public functions will have comment based help' {

    $step = @{keyword = 'Then'}
    foreach($command in (Get-Command -Module $ModuleName  ))
    {
        $step.text = ('{0} will have comment based help' -f $command.Name)           
        Invoke-GherkinStep $step -Pester $Pester -verbose

        $step.keyword = 'And'
    }
}




Given 'we have (?<folder>(public)) functions?' {
    param($folder)
    "$psscriptroot\..\psgraph\$folder\*.ps1" | Should Exist
}

Given 'we have a (?<name>.+?) function' {
    param($name)
    "$psscriptroot\..\psgraph\*\$name.ps1" | Should Exist
}

Given 'We have these functions' {
    param($table)
    foreach ($row in $table)
    {
        $step = @{
            text = ('we have a {0} function' -f $row.Name)
            keyword = 'Given'           
        }
    
        Invoke-GherkinStep $step -Pester $pester -Verbose
    }    
}

Given "extra text" {    
    Param($value)
    $value.count | should be 1
}

