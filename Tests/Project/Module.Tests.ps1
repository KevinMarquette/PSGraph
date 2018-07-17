$Script:ModuleRoot = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$Script:ModuleName = $Script:ModuleName = Get-ChildItem $ModuleRoot\*\*.psm1 | Select-object -ExpandProperty BaseName

$Script:SourceRoot = Join-Path -Path $ModuleRoot -ChildPath $ModuleName

Describe "All commands pass PSScriptAnalyzer rules" -Tag 'Build' {
    $rules = "$ModuleRoot\ScriptAnalyzerSettings.psd1"
    $scripts = Get-ChildItem -Path $SourceRoot -Include '*.ps1', '*.psm1', '*.psd1' -Recurse |
        Where-Object FullName -notmatch 'Classes'

    foreach ($script in $scripts)
    {
        Context $script.FullName {
            $results = Invoke-ScriptAnalyzer -Path $script.FullName -Settings $rules
            if ($results)
            {
                foreach ($rule in $results)
                {
                    It $rule.RuleName {
                        $message = "{0} Line {1}: {2}" -f $rule.Severity, $rule.Line, $rule.Message
                        $message | Should Be ""
                    }
                }
            }
            else
            {
                It "Should not fail any rules" {
                    $results | Should BeNullOrEmpty
                }
            }
        }
    }
}

Describe "Public commands have Pester tests" -Tag 'Build' {
    $commands = Get-Command -Module $ModuleName

    foreach ($command in $commands.Name)
    {
        $file = Get-ChildItem -Path "$ModuleRoot\Tests" -Include "$command.Tests.ps1" -Recurse
        It "Should have a Pester test for [$command]" {
            $file.FullName | Should Not BeNullOrEmpty
        }
    }
}
