function Install-GraphViz
{
    <#
        .Description
        Installs GraphViz package
        .Example
        Install-GraphViz
    #>
    [cmdletbinding()]
    param()

    if ($IsOSX)
    {
        brew install graphviz
    }
    else
    {
        Find-Package graphviz | Install-Package -Verbose -ForceBootstrap
    }
    
}
