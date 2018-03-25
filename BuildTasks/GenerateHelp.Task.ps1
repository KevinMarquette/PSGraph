
task GenerateHelp {
    if (-not(Get-ChildItem -Path $DocsPath -Filter '*.md' -Recurse -ErrorAction 'Ignore'))
    {
        "No Markdown help files to process. Skipping help file generation..."
        return
    }

    $locales = (Get-ChildItem -Path $DocsPath -Directory).Name
    foreach ($locale in $locales)
    {
        $params = @{
            ErrorAction            = 'SilentlyContinue'
            Force                  = $true
            OutputPath             = "$Destination\en-US"
            Path                   = "$DocsPath\en-US"
        }

        # Generate the module's primary MAML help file.
        "Creating new External help for [$ModuleName]..."
        $null = New-ExternalHelp @params
    }
}
