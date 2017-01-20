function Invoke-GraphViz
{
    <#
    .Description
    Invokes the graphviz binaries to generate a graph
    #>
    [cmdletbinding()]
    param(
        # Parameter help description
        [Parameter(ValueFromPipeline)]
        [string[]]
        $Path,

        [ValidateSet('DOT')]
        $Engine = 'DOT',

        [switch]
        $Version,
        [string]
        $GraphName,
        [string]
        $NodeName,
        [string]
        $EdgeName,
        [string]
        $OutputFormat,
        [string]
        $LayoutEngine,
        [string]
        $ExternalLibrary,
        [string]
        $DestinationPath,
        [string]
        $AutoName

    )

    begin
    {
        $paramLookup = @{
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
        }
        $graphViz = Resolve-Path  -path 'c:\program files*\GraphViz*\bin\dot.exe'
    }
    process
    {
        Write-Verbose "Checking lookup table for options"
        $arguments = @()
        
        foreach($key in $PSBoundParameters.keys)
        {
            Write-Verbose $key
            if($key -ne $null -and $paramLookup.ContainsKey($key))
            {
                $newArgument = $paramLookup[$key]
                if($newArgument -like '*{0}*')
                {
                    $newArgument = $newArgument -f $PSBoundParameters[$key]
                }
                Write-Verbose $newArgument
                $arguments += "-$newArgument"
            }            
        }

        foreach($file in (Resolve-Path -Path $Path))
        {
            $arguments | %{Write-Verbose $_ }
            $null = Start-Process -FilePath $graphViz -ArgumentList ($arguments + $file.path) -Wait -NoNewWindow
        }
    }
}