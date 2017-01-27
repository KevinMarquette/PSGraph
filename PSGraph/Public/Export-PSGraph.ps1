function Export-PSGraph
{
    <#
        .Description
        Invokes the graphviz binaries to generate a graph.

        .Example
        Export-PSGraph -Source graph.dot -OutputFormat png

        .Example
        graph g {
            edge (3..6)
            edge (5..2)
        } | Export-PSGraph -Destination $env:temp\test.png

        .Notes
        The source can either be files or piped graph data.

        It checks the piped data for file paths. If it can't find a file, it assumes it is graph data.
        This may give unexpected errors when the file does not exist.
    #>
    
    [cmdletbinding()]
    param(
        # The GraphViz file to process or contents of the graph in Dot notation
        [Parameter(
            ValueFromPipeline = $true
        )]
        [Alias('InputObject','Graph','SourcePath')]
        [string[]]
        $Source,

        #The destination for the generated file.
         [Parameter(            
            Position = 0
        )]
        [string]
        $DestinationPath,

        # The file type used when generating an image
        [ValidateSet('jpg','png','gif','imap','cmapx','jp2','json','pdf','plain','dot')]
        [string]
        $OutputFormat = 'png',
        
        # The layout engine used to generate the image
        [ValidateSet(
            'Hierarchical',
            'SpringModelSmall' ,
            'SpringModelMedium', 
            'SpringModelLarge', 
            'Radial',
            'Circular'
        )]
        [string]
        $LayoutEngine,

        # launches the graph when done
        [switch]
        $ShowGraph
    )

    begin
    {
        $graphViz = Resolve-Path -path 'c:\program files*\GraphViz*\bin\dot.exe'
        if($graphViz -eq $null)
        {
            throw "Could not find GraphViz installed on this system. Please run 'Find-Package graphviz | Install-Package -ForceBootstrap' or 'Install-GraphViz' to install the needed binaries and libraries. This module just a wrapper around GraphViz and is looking for it in your program files folder."
        }

        $useStandardInput = $false
        $standardInput = New-Object System.Text.StringBuilder
    }

    process
    {     
        
        if($Source -ne $null)
        {

            # if $Source is a list of files, process each one
            $fileList = Resolve-Path -Path $Source -ea 0
            if($fileList -ne $null)
            {
                foreach($file in $fileList )
                {     
                    Write-Verbose "Generating graph from '$($file.path)'"
                    $arguments = Get-GraphVizArguments -InputObject $PSBoundParameters
                    & $graphViz @($arguments + $file.path)
                }
            } 
            else 
            {
                Write-Debug 'Using standard input to process graph'
                $useStandardInput = $true                
                [void]$standardInput.AppendLine($Source)            
            }    
        }
    }

    end
    {
        if($useStandardInput)
        {
            Write-Verbose 'Processing standard input'
           
            if(-Not $PSBoundParameters.ContainsKey('DestinationPath'))
            {
               $file = [System.IO.Path]::GetRandomFileName()               
               $PSBoundParameters["DestinationPath"] = Join-Path $env:temp "$file.$OutputFormat"
               $PSBoundParameters["OutputFormat"] = $OutputFormat
            }
            $arguments = Get-GraphVizArguments $PSBoundParameters
             Write-Verbose " Arguments: $($arguments -join ' ')"

            $standardInput.ToString() | & $graphViz @($arguments)
            

            if($ShowGraph)
            {
                # Launches image with default viewer as decided by explorer
                Write-Verbose "Launching $($PSBoundParameters["DestinationPath"])"
                Invoke-Expression $PSBoundParameters["DestinationPath"]
            }

            Write-Output (Get-ChildItem $PSBoundParameters["DestinationPath"])
        }
    }
}
