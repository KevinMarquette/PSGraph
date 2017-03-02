function Get-OutputFormatFromPath([string]$path)
{
    $formats = @(
        'jpg'
        'png'
        'gif'
        'imap'
        'cmapx'
        'jp2'
        'json'
        'pdf'
        'plain'
        'dot'
    )

    foreach($ext in $formats)
    {
        if($Path -like "*.$ext")
        {
            return $ext
        }
    }
}
