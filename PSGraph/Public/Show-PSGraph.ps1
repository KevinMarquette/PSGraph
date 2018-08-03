function Show-PSGraph
{
    <#

    .ForwardHelpTargetName Export-PSGraph
    .ForwardHelpCategory Function
    .Notes
    To regenerate most of this proxy function
    $MetaData = New-Object System.Management.Automation.CommandMetaData (Get-Command  Export-PSGraph) 
    $proxy = [System.Management.Automation.ProxyCommand]::Create($MetaData)

    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [Alias('InputObject', 'Graph', 'SourcePath')]
        [string[]]
        ${Source},

        [Parameter(Position = 0)]
        [string]
        ${DestinationPath},

        [ValidateSet('jpg', 'png', 'gif', 'imap', 'cmapx', 'jp2', 'json', 'pdf', 'plain', 'dot', 'svg')]
        [string]
        ${OutputFormat},

        [ValidateSet('Hierarchical', 'SpringModelSmall', 'SpringModelMedium', 'SpringModelLarge', 'Radial', 'Circular', 'dot', 'neato', 'fdp', 'sfdp', 'twopi', 'circo')]
        [string]
        ${LayoutEngine},

        [string[]]
        ${GraphVizPath}
    )

    begin
    {
        try
        {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Export-PSGraph', [System.Management.Automation.CommandTypes]::Function)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters -ShowGraph }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline()
            $steppablePipeline.Begin($PSCmdlet)
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
            $steppablePipeline.Process($_)
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSitem )
        }
    }

    end
    {
        try
        {
            $steppablePipeline.End()
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSitem )
        }
    }
}