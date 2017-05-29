Given 'our function is named (?<Function>>*)' {
    param($Function)

    $script:Function = Get-Command -Name $Function -Module $ModuleName
    $script:Function | Should Not BeNullOrEmpty
}


