Given 'the module was named (\S*)' {
    Param($Name)
    $Script:ModuleName = $Name

    $path = "$PSScriptRoot\.."
    $module = Get-ChildItem -Path $path -Recurse -Filter "$ModuleName.psm1" -verbose
    $module | should not benullorempty
    $module.fullname | Should Exist

    $Script:ModuleSource = "$PSScriptRoot\..\$ModuleName"
    $Script:ModuleOutput = "$PSScriptRoot\..\Output\$ModuleName"
}

Given 'we use the (\S*) root folder' {
    Param($root)
    Switch ($root)
    {
        'Project'
        {
            $script:BaseFolder = Resolve-Path "$PSScriptRoot\.." | Select -ExpandProperty Path
        }
        'ModuleSource'
        {
            $script:BaseFolder = $Script:ModuleSource
        }
        'ModuleOutput'
        {
            $script:BaseFolder = $Script:ModuleOutput
        }
    }
}

Then 'it (will have|had) a (?<Path>\S*) (file|folder).*' {
    Param($Path)

    Join-Path $script:BaseFolder $Path | Should Exist
}

When 'the module (is|can be) imported' {
    { Import-Module $ModuleOutput -Force } | Should Not Throw
}

Then 'Get-Module will show the module' {
    Get-Module -Name $ModuleName | Should Not BeNullOrEmpty
}

Then 'Get-Command will list functions' {
    Get-Command -Module $ModuleName | Should Not BeNullOrEmpty
}

Then '(function )?(?<Function>\S*) will be listed in module manifest' {
    Param($Function)
    (Get-Content $ModuleSource\$ModuleName.psd1 -Raw) -match [regex]::Escape($Function) | Should Be $true
}

Then '(function )?(?<Function>\S*) will contain (?<Text>.*)' {
    Param($Function, $Text)
    $Command = Get-Command $Function -Module $ModuleName
    $match = [regex]::Escape($Text)
    ($Command.Definition -match $match ) | Should Be True
}

Then '(function )?(?<Function>\S*) will have comment based help' {
    Param($Function)
    $help = Get-Help $Function
    $help | Should Not BeNullOrEmpty
}

Then 'will have readthedoc pages' {
    { Invoke-Webrequest -uri "https://$ModuleName.readthedocs.io" -UseBasicParsing } | Should Not Throw
}

Then '(function )?(?<Function>\S*) will have a feature specification or a pester test' {
    param($Function)

    $file = Get-ChildItem -Path $PSScriptRoot\.. -Include "$Function.feature", "$Function.Tests.ps1" -Recurse
    $file.fullname | Should Not BeNullOrEmpty
}

Then 'all public functions (?<Action>.*)' {
    Param($Action)
    $step = @{keyword = 'Then'}
    $AllPassed = $true
    foreach ($command in (Get-Command -Module $ModuleName  ))
    {
        $step.text = ('function {0} {1}' -f $command.Name, $Action )           
        
        Invoke-GherkinStep $step -Pester $Pester -Visible
        If ( -Not $Pester.TestResult[-1].Passed )
        {
            $AllPassed = $false
        } 

        $step.keyword = 'And'
    }
    $AllPassed | Should be $true
}

Then 'will be listed in the PSGallery' {
    Find-Module $ModuleName | Should Not BeNullOrEmpty
}

Given 'we have (?<folder>(public)) functions?' {
    param($folder)
    "$psscriptroot\..\psgraph\$folder\*.ps1" | Should Exist
}

Then 'all script files pass PSScriptAnalyzer rules' {
    
    $Rules = Get-ScriptAnalyzerRule
    $scripts = Get-ChildItem $BaseFolder -Include *.ps1, *.psm1, *.psd1 -Recurse | where fullname -notmatch 'classes'
   
    $AllPassed = $true

    foreach ($Script in $scripts )
    {      
        $file = $script.fullname.replace($BaseFolder, '$')
       

        context $file {
        
            foreach ( $rule in $rules )
            {
                It " [$file] Rule [$rule]" {

                    (Invoke-ScriptAnalyzer -Path $script.FullName -IncludeRule $rule.RuleName ).Count | Should Be 0
                }
            }
        }

        If ( -Not $Pester.TestResult[-1].Passed )
        {
            $AllPassed = $false
        } 
    }
    
    $AllPassed | Should be $true
}
