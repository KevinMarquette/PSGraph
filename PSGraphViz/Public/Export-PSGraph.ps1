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

        $paramLookup = @{
            # OutputFormat
            Version = 'V'
            Debug = 'v'
            GraphName = 'Gname={0}'
            NodeName = 'Nname={0}'
            EdgeName = 'Ename={0}'
            OutputFormat = 'T{0}'
            LayoutEngine = 'K{0}'
            ExternalLibrary = 'l{0}'
            DestinationPath = 'o{0}'
            AutoName = 'O'

            #LayoutEngine
            Hierarchical = 'dot'
            SpringModelSmall = 'neato'
            SpringModelMedium = 'fdp'
            SpringModelLarge = 'sfdp'
            Radial = 'twopi'
            Circular = 'circo'

        }
         Write-Verbose "Checking lookup table for options"
        $arguments = @()
        
        if($PSBoundParameters.ContainsKey('LayoutEngine'))
        {
            Write-Verbose 'Looking up and replacing rendering engine string'
            $PSBoundParameters['LayoutEngine'] = $paramLookup[$PSBoundParameters['LayoutEngine']]
        }

        if( -Not $PSBoundParameters.ContainsKey('DestinationPath'))
        {
            $PSBoundParameters["AutoName"] = $true;
        }

        if( -Not $PSBoundParameters.ContainsKey('OutputFormat'))
        {
            Write-Verbose "Tryig to set OutputFormat to match file extension"
            $PSBoundParameters["OutputFormat"] = $OutputFormat;
            $formats = @('jpg','png','gif','imap','cmapx','jp2','json','pdf','plain','dot')

            foreach($ext in $formats)
            {
                if($DestinationPath -like "*.$ext")
                {
                    $PSBoundParameters["OutputFormat"] = $ext
                }
            }
        }

        Write-Verbose 'Walking parameter mapping'
        foreach($key in $PSBoundParameters.keys)
        {
            Write-Debug $key
            if($key -ne $null -and $paramLookup.ContainsKey($key))
            {
                $newArgument = $paramLookup[$key]
                if($newArgument -like '*{0}*')
                {
                    $newArgument = $newArgument -f $PSBoundParameters[$key]
                }

                Write-Debug $newArgument
                $arguments += "-$newArgument"
            }            
        }
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
            Write-Debug " Arguments: $($arguments -join ' ')"
            $standardInput.ToString() | & $graphViz @($arguments)

            if($ShowGraph)
            {
                # Launches image with default viewer as decided by explorer
                Write-Verbose "Launching $(Resolve-Path $DestinationPath)"
                Invoke-Expression (Resolve-Path $DestinationPath)
            }
        }
    }
}
