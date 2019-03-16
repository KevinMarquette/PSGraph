function Format-Value
{
    param(
        $value,

        [switch]
        $Edge,

        [switch]
        $Node
    )

    begin
    {
        if ( $null -eq $Script:CustomFormat )
        {
            Set-NodeFormatScript
        }
    }
    process
    {
        # edges can point to record cells
        if ($Edge -and
            # is not surounded by explicit quotes
            $value -notmatch '^".*"$' -and
            # has record notation with a word as a target
            $value -match '^(?<node>.+):(?<Record>(\w+))$'
        )
        {
            # Recursive call to this function to format just the node
            "{0}:{1}" -f (Format-Value $matches.node -Node), $matches.record
        }
        else
        {
            # Allows for custom node ID formats
            if ( $Edge -Or $Node )
            {
                $value = @($value).ForEach($Script:CustomFormat)
            }

            switch -Regex ( $value )
            {
                # HTML label, special designation
                '^<\s*table.*>.*'
                {
                    "<$PSItem>"
                }
                '^".*"$'
                {
                    [string]$PSItem
                }
                # Anything else, use quotes
                default
                {
                    '"{0}"' -f ( [string]$PSItem ).Replace("`"", '\"') # Escape quotes in the string value
                }
            }
        }
    }
}
