function Export-PSGraph
{
    <#
        .Description
        Invokes the graphviz binaries to generate a graph.
        .PARAMETER Source
        The GraphViz file to process or contents of the graph in Dot notation
        .PARAMETER DestinationPath
        The destination for the generated file.
        .PARAMETER OutputFormat
        The file type used when generating an image
        .PARAMETER LayoutEngine
        The layout engine used to generate the image
        .PARAMETER GraphVizPath
        Path or paths to the 'dot' graphviz executable. Some sensible defaults are used if nothing is passed.
        .PARAMETER ShowGraph
        Launches the graph when done
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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
    [cmdletbinding()]
    param(
        # The GraphViz file to process or contents of the graph in Dot notation
        [Parameter(
            ValueFromPipeline = $true
        )]
        [Alias('InputObject', 'Graph', 'SourcePath')]
        [string[]]
        $Source,

        #The destination for the generated file.
        [Parameter(
            Position = 0
        )]
        [string]
        $DestinationPath,

        # The file type used when generating an image
        [ValidateSet('jpg', 'png', 'gif', 'imap', 'cmapx', 'jp2', 'json', 'pdf', 'plain', 'dot')]
        [string]
        $OutputFormat = 'png',

        # The layout engine used to generate the image
        [ValidateSet(
            'Hierarchical',
            'SpringModelSmall' ,
            'SpringModelMedium',
            'SpringModelLarge',
            'Radial',
            'Circular',
            'dot',
            'neato',
            'fdp',
            'sfdp',
            'twopi',
            'circo'
        )]
        [string]
        $LayoutEngine,

        [Parameter()]
        [string[]]
        $GraphVizPath = (
            'C:\Program Files\NuGet\Packages\Graphviz*\dot.exe',
            'C:\program files*\GraphViz*\bin\dot.exe',
            '/usr/local/bin/dot'
        ),

        # launches the graph when done
        [switch]
        $ShowGraph
    )

    begin
    {
        try
        {
            # Use Resolve-Path to test all passed paths
            # Select only items with 'dot' BaseName and use first one
            $graphViz = Resolve-Path -path $GraphVizPath -ErrorAction SilentlyContinue | Get-Item | Where-Object BaseName -eq 'dot' | Select-Object -First 1

            if ( $null -eq $graphViz )
            {
                throw "Could not find GraphViz installed on this system. Please run 'Install-GraphViz' to install the needed binaries and libraries. This module just a wrapper around GraphViz and is looking for it in your program files folder. Optionally pass a path to your dot.exe file with the GraphVizPath parameter"
            }

            $useStandardInput = $false
            $standardInput = New-Object System.Text.StringBuilder
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSitem )
        }
    }

    process
    {
        try
        {
            if ( $null -ne $Source -and $Source.Count -gt 0 )
            {
                # if $Source is a list of files, process each one
                $fileList = $null

                # Only resolve paths, if there are NO empty string entries in the $Source
                # Resolve-path spits out an error with empty string paths, even with SilentlyContinue
                if ( @( $Source | Where-Object { [String]::IsNullOrEmpty($_) } ).Count -eq 0 )
                {
                    try 
                    {
                        $fileList = Resolve-Path -Path $Source -ErrorAction Stop
                    }
                    catch 
                    {
                        # I don't care that it isn't a file, I'll do something else with the data
                        $fileList = $null
                    }
                }

                if ( $null -ne $fileList -and $Source.Count -gt 0 )
                {
                    foreach ( $file in $fileList )
                    {
                        Write-Verbose "Generating graph from '$($file.path)'"
                        $arguments = Get-GraphVizArgument -InputObject $PSBoundParameters
                        $output = & $graphViz @($arguments + $file.path)
                        if ($LastExitCode)
                        {
                            Write-Error -ErrorAction Stop -Exception ([System.Management.Automation.ParseException]::New())
                        }
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
        catch
        {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }

    end
    {
        try
        {

            if ( $useStandardInput )
            {
                Write-Verbose 'Processing standard input'
                if ( -Not $PSBoundParameters.ContainsKey( 'DestinationPath' ) )
                {
                    Write-Verbose '  Creating temporary path to save graph'

                    if ( $standardInput[0] -match 'graph\s+(?<filename>.+)\s+{' )
                    {
                        $file = $Matches.filename
                    }
                    else
                    {
                        $file = [System.IO.Path]::GetRandomFileName()
                    }
                    $PSBoundParameters["DestinationPath"] = Join-Path ([system.io.path]::GetTempPath()) "$file.$OutputFormat"
                }

                $arguments = Get-GraphVizArgument $PSBoundParameters
                Write-Verbose " Arguments: $($arguments -join ' ')"

                $output = $standardInput.ToString() | & $graphViz @($arguments)
                if ($LastExitCode)
                {
                    Write-Error -ErrorAction Stop -Exception ([System.Management.Automation.ParseException]::New())
                }

                if ( $ShowGraph )
                {
                    # Launches image with default viewer as decided by explorer
                    Write-Verbose "Launching $($PSBoundParameters["DestinationPath"])"
                    Invoke-Expression $PSBoundParameters["DestinationPath"]
                }

                Get-ChildItem $PSBoundParameters["DestinationPath"]
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
}
