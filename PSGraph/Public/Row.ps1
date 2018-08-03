function Row
{
    <#
    .SYNOPSIS
    Adds a row to a record

    .Description
    Adds a row to a record inside a PSGraph Graph

    .PARAMETER Label
    This is the displayed data for the row

    .PARAMETER Name
    This is the target name of this row to be used in edges.
    Will default to the label if the label has not special characters

    .PARAMETER HtmlEncode
    This will encode unintentional HTML. Characters like <>& would break html parsing if they are
    contained in the source data.

    .EXAMPLE
    graph {

        Record Components1 @(
            'Name'
            'Environment'
            'Test <I>[string]</I>'
        )

        Record Components2 {
            Row Name
            Row 'Environment <B>test</B>'
            'Test'
        }


        Edge Components1:Name -to Components2:Name

    } | Export-PSGraph -ShowGraph

    .NOTES
    Need to add attribute support

    DSL planned syntax
    # Row Label
    # Row Label -ID
    # Row Label Attributes
    # Row Label -ID Attributes

    #>
    [OutputType('System.String')]
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline
        )]
        [string]
        $Label,

        [alias('ID')]
        [string]
        $Name,

        [switch]
        $HtmlEncode
    )
    process
    {
        if ( [string]::IsNullOrEmpty($Name) )
        {
            if ($Label -notmatch '[<,>\s]')
            {
                $Name = $Label
            }
            else
            {
                $Name = New-Guid
            }
        }

        if ($Label -match '^<TR>.*</TR>?')
        {
            $Label
        }
        else
        {
            if ($HtmlEncode)
            {
                $Label = ([System.Net.WebUtility]::HtmlEncode($Label))
            }
            '<TR><TD PORT="{0}" ALIGN="LEFT">{1}</TD></TR>' -f $Name, $Label
        }
    }
}