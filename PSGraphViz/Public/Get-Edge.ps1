function Get-Edge 
{

    param(
        [string[]]
        $From,

        [string[]]
        $To,

        [hashtable]
        $Attributes
    )

    if($Attributes -ne $null)
    {
        $GraphVizAttribute = ConvertTo-GraphVizAttribute -Attributes $Attributes
    }

    if($To -ne $null)
    {
        foreach($sNode in $From)
        {
            foreach($tNode in $To)
            {
                '{0}"{1}"->"{2}" {3}' -f (Get-Indent), $sNode, $tNode, $GraphVizAttribute
            }
        }
    }
    else
    {
        for($index=0; $index -lt ($From.Count - 1); $index++)
        {
            '{0}"{1}"->"{2}" {3}' -f (Get-Indent), $From[$index], $From[$index + 1], $GraphVizAttribute
        }
    }
}
