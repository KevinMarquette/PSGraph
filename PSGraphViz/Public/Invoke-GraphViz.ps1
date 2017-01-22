function Invoke-GraphViz
{
    <#
    .Description
    Invokes the graphviz binaries to generate a graph.

    .Example
    Invoke-GraphViz -Path graph.dot -OutputFormat png
    .Example
    $folders = Get-ChildItem -Recuse -Directory 
    $folders | New-QuickGraph -LeftProperty Parent -RightProperty Name | Set-Content -Path Folder.vz
    Invoke-GraphViz -Path folder.vz -OutputFormat png
    #>
    [cmdletbinding()]
    param(
        # The GraphViz file to process
        [Parameter(ValueFromPipeline)]
        [string[]]
        $Path,

        [switch]
        $Version,

        [string]
        $GraphName,

        [string]
        $NodeName,

        [string]
        $EdgeName,

        # The file type used when generating an image
        [ValidateSet('jpg','png','gif','imap','cmapx','jp2','json','pdf','plain')]
        [string]
        $OutputFormat = 'png',

        # The layout engine used to generate the image
        [string]
        [ValidateSet(
            'Hierarchical',
            'SpringModelSmall' ,
            'SpringModelMedium', 
            'SpringModelLarge', 
            'Radial',
            'Circular'
        )]
        $LayoutEngine,
        
        [string]
        $ExternalLibrary,

        #The destination for the generated file.
        [string]
        $DestinationPath,

        # When set, this will attach the file extention to the existing nam
        [switch]
        $AutoName

    )

    begin
    {
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
        $graphViz = Resolve-Path -path 'c:\program files*\GraphViz*\bin\dot.exe'
        if($graphViz -eq $null)
        {
            throw "Could not find GraphViz installed on this system. Please run 'Find-Package graphviz | Install-Package -ForceBootstrap' or 'Install-GraphViz' to install the needed binaries and libraries. This module just a wrapper around GraphViz and is looking for it in your program files folder."
        }
    }
    process
    {
        Write-Verbose "Checking lookup table for options"
        $arguments = @()
        
        if($PSBoundParameters.ContainsKey('LayoutEngine'))
        {
            Write-Verbose 'Looking up and replacing rendering engine string'
            $PSBoundParameters['LayoutEngine'] = $paramLookup[$PSBoundParameters['LayoutEngine']]
        }

        if( -Not $PSBoundParameters.ContainsKey('LayoutEngine'))
        {
            $PSBoundParameters["AutoName"] = $true;
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

        Write-Verbose 'Generating graph file'
        foreach($file in (Resolve-Path -Path $Path))
        {     
            Start-Process -FilePath $graphViz -ArgumentList ($arguments + $file.path) -Wait -NoNewWindow
        }
    }
}