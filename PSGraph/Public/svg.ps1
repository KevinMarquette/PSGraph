function svg {
    <#
      .Description
        Wraps the graph and export graph functions to generate a graph in one go
        has aliases cmapxGraph, DiGraph, dotGraph, gifGraph, imapGraph, jp2Graph, jpgGraph, jsonGraph, pdfGraph, plainGraph, pngGraph, svgGraph
        to output different kinds of graph
      .Example
        svg -ShowGraph  { Node $PWD @{label = $Html; shape = 'none';}}
        This creates a single node graph (although the script block could be much longer).
        The graph is output to a SVG file with a  system generated name in the TEMP folder and opened in the default viewer
        Here $html contains a table which describes the current directory.
        .Example
        jpgGraph "$env:USERPROFILE\documents\graph" { Node $PWD @{label = $H  ; shape = 'none'; fontname = "Consolas"; }}
        This creates the same graph as before but this time the command is called using the jpgGraph alias, so the output is
        in JPG format. A file name is given but because it does not in in .jpg, that will be added
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( "PSAvoidDefaultValueForMandatoryParameter", "" )]
    [CmdletBinding( DefaultParameterSetName = 'Default' )]
    [Alias( 'DiGraph' )]
    [OutputType( [string] )]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'Path'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'PathAttributes'
        )]
        [Alias('Path')]
        [string]
        $DestinationPath,

        # The commands to execute inside the graph
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'Default'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 1,
            ParameterSetName = 'Path'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 1,
            ParameterSetName = 'Attributes'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 2,
            ParameterSetName = 'PathAttributes'
        )]
        [scriptblock]
        $ScriptBlock,

        # Hashtable that gets translated to graph attributes
        [Parameter(
            Mandatory = $true,
            Position = 1,
            ParameterSetName = 'PathAttributes'
        )]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'Attributes'
        )]
        [hashtable]
        $Attributes = @{},

        # Keyword that initiates the graph
        [string]
        $Type ,

        # Name or ID of the graph
        [string]$Name ,

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
        $GraphVizPath,


        # launches the graph when done
        [switch]
        $ShowGraph
    )

    if (-not $PSBoundParameters.ContainsKey('Name')) {$PSBoundParameters['Name'] = 'PSGraph'}
    $format = $MyInvocation.InvocationName.replace('Graph','').ToLower()
    $exportParams = @{OutputFormat = $format }
    if ($DestinationPath -and $format -in @('dot','gif','jpg','png', 'pdf', 'svg') -and $DestinationPath -notmatch "\.$format$") {
        $PSBoundParameters['DestinationPath'] += ".$format"
    }
    foreach ($var in 'ShowGraph', 'GraphVizPath', 'LayoutEngine','DestinationPath') {
        if  ($PSBoundParameters.ContainsKey($var)) {
            $exportParams[$var] = $PSBoundParameters[$var]
            [void]$PSBoundParameters.Remove($var)
        }
    }
    graph @PSBoundParameters  | Export-PSGraph @exportParams
}


foreach ($outputType in @('jpg', 'png', 'gif', 'imap', 'cmapx', 'jp2', 'json', 'pdf', 'plain', 'dot','svg')) {
    New-Alias -Name "$outputType`Graph" -Value svg -Force -Scope  Global
}
