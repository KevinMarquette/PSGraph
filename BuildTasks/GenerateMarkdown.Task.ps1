
task GenerateMarkdown {
    $module = Import-Module -FullyQualifiedName $ManifestPath -Force -PassThru

    try
    {
        if ($module.ExportedFunctions.Count -eq 0)
        {
            'No functions have been exported for this module. Skipping Markdown generation...'
            return
        }

        if (Get-ChildItem -Path $DocsPath -Filter '*.md' -Recurse)
        {
            $items = Get-ChildItem -Path $DocsPath -Directory -Recurse
            foreach ($item in $items)
            {
                "Updating Markdown help in [$($item.BaseName)]..."
                $null = Update-MarkdownHelp -Path $item.FullName -AlphabeticParamsOrder
            }
        }

        $params = @{
            AlphabeticParamsOrder  = $true
            ErrorAction           = 'SilentlyContinue'
            Locale                = 'en-US'
            Module                = $ModuleName
            OutputFolder          = "$DocsPath\en-US"
            WithModulePage        = $true
        }

        # ErrorAction is set to SilentlyContinue so this
        # command will not overwrite an existing Markdown file.
        "Creating new Markdown help for [$ModuleName]..."
        $null = New-MarkdownHelp @params
    }
    finally
    {
        Remove-Module -Name $ModuleName -Force
    }
}
