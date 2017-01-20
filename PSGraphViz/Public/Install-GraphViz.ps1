function Install-GraphViz
{
    [cmdletbinding()]
    param()

    Find-Package graphviz | Install-Package -Verbose -ForceBootstrap
}