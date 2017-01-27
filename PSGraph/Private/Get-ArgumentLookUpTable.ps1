Function Get-ArgumentLookupTable
{
    return @{
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
    }
}
