function Format-KeyName
{
    [OutputType('System.String')]
    [cmdletbinding()]
    param(
        [Parameter(Position = 0)]
        [string]
        $InputObject
    )
    begin
    {
        $translate = @{
            Damping = 'Damping'
            K       = 'K'
            URL     = 'URL'
        }
    }
    process
    {
        $InputObject = $InputObject.ToLower()
        if ( $translate.ContainsKey( $InputObject ) )
        {
            return $translate[ $InputObject ]
        }
        return $InputObject
    }
}