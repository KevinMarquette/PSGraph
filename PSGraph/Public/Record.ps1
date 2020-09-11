
function Record
{
    <#
    .SYNOPSIS
    Creates a record object

    .DESCRIPTION
    Creates a record object that contains rows of data.

    .PARAMETER Name
    The node name for this record

    .PARAMETER Row
    An array of strings/objects to place in this record

    .PARAMETER RowScript
    A script to run on each row

    .PARAMETER ScriptBlock
    A sub expression that contains Row commands

    .PARAMETER Label
    The label to use for the header of the record, will default to the name if not set

    .PARAMETER TitlePosition
    Specifies where the label should appear, either top, bottom or none.

    .PARAMETER TableStyle
    Formatting applied to the table displaying the record, defaults to 'CELLBORDER="1" BORDER="0" CELLSPACING="0"',

    .PARAMETER TitleSpan
    Specifies the number of columns the title should span, if the rows in the record have multiple columns.

    .PARAMETER FontName
    Specifies the font to use for the record, defaults to "Courier New"

    .PARAMETER FillColor
    Background color for the record, defaults to "white"

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


        Echo one two three | Record Fish
        Record Cow red,blue,green

    } | Export-PSGraph -ShowGraph

    .NOTES
    Early release version of this command.
    A lot of stuff is hard coded that should be exposed as attributes

    #>
    [OutputType('System.String')]
    [cmdletbinding(DefaultParameterSetName = 'Script')]
    param(
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [alias('ID', 'Node')]
        [string]
        $Name,

        [Parameter(
            Position = 1,
            ValueFromPipeline,
            ParameterSetName = 'Strings'
        )]
        [alias('Rows')]
        [Object[]]
        $Row,

        [Parameter(
            Position = 1,
            ParameterSetName = 'Script'
        )]
        [ScriptBlock]
        $ScriptBlock,

        [Parameter(
            Position = 2
        )]
        [ScriptBlock]
        $RowScript,

        [string]
        $Label,

        [string]
        $TableStyle = 'CELLBORDER="1" BORDER="0" CELLSPACING="0"',

        [string]
        $fontName = "Courier New",

        [string]
        $FillColor = "white",

        [int16]
        $TitleSpan,

        [ValidateSet('Top','Bottom','None')]
        [string]
        $TitlePosition = 'Top'
    )
    begin
    {
        $tableData = [System.Collections.ArrayList]::new()
        if ( [string]::IsNullOrEmpty($Label) )
        {
            $Label = $Name
        }
        #re-create scriptblock passed as a parameter, otherwise variables in this function are out of its scope.
        if ($RowScript)
        {
            $RowScript   = [scriptblock]::create( $RowScript )
        }
    }
    process
    {
        if ( $null -ne $ScriptBlock )
        {
            $Row = $ScriptBlock.Invoke()
        }

        foreach ( $node in $Row )
        {
            #Collapsed multiple loops into one. Name will be empty UNLESS the script sets it.
            $RowName = ""
            if ( $null -ne $RowScript )
            {
                @($node).ForEach($RowScript)
            }
            [void]$tableData.Add((Row -Label $node -Name $Rowname))
        }
    }
    end
    {
        $Colspan = if ($TitleSpan) {'COLSPAN="{0}"' -f $TitleSpan} else { "" }
        $html = switch ($TitlePosition) {
            'None'   {'<TABLE {0}>{1}</TABLE>' -f $TableStyle, ($tableData -join '')}
            'Bottom' {'<TABLE {0}>{1}<TR><TD bgcolor="black" align="center" {2}><font color="white"><B>{3}</B></font></TD></TR></TABLE>' -f $TableStyle, ($tableData -join ''),$Colspan,$Label}
             Default {'<TABLE {0}><TR><TD bgcolor="black" align="center" {2}><font color="white"><B>{3}</B></font></TD></TR>{1}</TABLE>' -f $TableStyle, ($tableData -join ''),$Colspan,$Label}
        }
        Node $Name @{label = $html; shape = 'none'; fontname = $fontName; style = "filled"; penwidth = 1; fillcolor =$FillColor }
    }
}
