function Install-GraphViz
{
    <#
        .Description
        Installs GraphViz package using online provider
        .Example
        Install-GraphViz
    #>
    [cmdletbinding( SupportsShouldProcess = $true, ConfirmImpact = "High" )]
    param()

    process
    {
        try
        {
            if ( $IsOSX )
            {
                if ( $PSCmdlet.ShouldProcess( 'Install graphviz' ) )
                {
                    brew install graphviz
                }
            }
            else
            {
                if ( $PSCmdlet.ShouldProcess('Register Chocolatey provider and install graphviz' ) )
                {
                    if ( -Not ( Get-PackageProvider | Where-Object ProviderName -eq 'Chocolatey' ) )
                    {
                        Register-PackageSource -Name Chocolatey -ProviderName Chocolatey -Location http://chocolatey.org/api/v2/
                    }

                    Find-Package graphviz | Install-Package -Verbose -ForceBootstrap
                }
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSitem )
        }
    }
}
