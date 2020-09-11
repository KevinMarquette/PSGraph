function Cells
{
    [OutputType('System.String')]
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline
        )]
        $InputObject,

        $Properties = '*' ,
        [string[]]
        $ExcludeProperty,
        [ValidateSet('LEFT','CENTER','RIGHT')]
        $Align = "LEFT",
        [string]
        $PortPoroperty,
        [switch]
        $HtmlEncode,
        [switch]
        $NoHeader
    )
    begin {
        $portlist = @{}
        $script:Header = @()
    }
    process
    {
        foreach ($Targetdata in $InputObject) {
            if (-not $script:Header) {
                foreach ($p in $Properties) {
                    $InputObject.PSObject.Properties.where({$_.name -like $p}).Name | ForEach-Object {
                        if ($_ -notin $script:Header) {$script:Header += $_ }
                    }
                }
                foreach ($exclusion in $ExcludeProperty) {$script:Header = $script:Header -notlike $exclusion}
                if (-not $NoHeader) {
                    $row =  "<tr>"
                    foreach ($Name in $script:Header) {
                        $row += ('<TD ALIGN="{1}"><B>{0}</B></TD>' -f $Name, $Align.toupper())
                    }
                    $row + "</tr>"
                }
            }
            $row =  "<tr>"
            foreach ($Name in $script:Header) {
                $cellText = ($TargetData.$Name).tostring()
                $newPortName = $cellText -replace '\W',''

                if ( $PortPoroperty -eq $name -and -not $portlist[$newPortName])
                {
                    $row += ('<TD PORT="{1}" ALIGN="{0}">' -f  $Align.toupper(), $newPortName)
                    $portlist[$newPortName] = $true
                }
                else
                {
                    $row += ('<TD ALIGN="{0}">' -f  $Align.toupper())
                }
                if ($HtmlEncode)
                {
                    $row +=  ([System.Net.WebUtility]::HtmlEncode($cellText)) + '</TD>'
                }
                else {
                    $row += $cellText + '</TD>'
                }
            }
            $row + "</tr>"
        }
    }
}