function ConvertTo-GraphVizAttribute
{
    param(
        [hashtable]
        $Attributes,

        [switch]
        $UseGraphStyle
    )

    if($Attributes -ne $null -and $Attributes.Keys.Count -gt 0)
    {
        if($UseGraphStyle)
        {
            $Attributes.GetEnumerator() | ForEach-Object {'{0}{1}="{2}";'-f (Get-Indent), $_.name, $_.value}
        }
        else
        {
            $values = $Attributes.GetEnumerator() | ForEach-Object {'{0}="{1}"'-f $_.name, $_.value}
            "[{0}]" -f ($values -join ';')
        }
    }
}
