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

    Find-Package graphviz | Install-Package -Verbose -ForceBootstrap
}
