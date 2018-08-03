
function Record
{
    <#
    .SYNOPSIS
    Creates a record object

    .DESCRIPTION
    Creates a record object that contains rows of data.

    .PARAMETER Name
    The node name for this record

    .PARAMETER Label
    The label to use for the headder of the record.

    .PARAMETER Row
    An array of strings/objects to place in this record

    .PARAMETER RowScript
    A script to run on each row

    .PARAMETER ScriptBlock
    A sub expression that contains Row commands

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
        $Label
    )
    begin
    {
        $tableData = [System.Collections.ArrayList]::new()
        if ( [string]::IsNullOrEmpty($Label) )
        {
            $Label = $Name
        }
    }
    process
    {
        if ( $null -ne $ScriptBlock )
        {
            $Row = $ScriptBlock.Invoke()
        }

        if ( $null -ne $RowScript )
        {
            $Row = foreach ( $node in $Row )
            {
                @($node).ForEach($RowScript)
            }
        }

        $results = foreach ( $node in $Row )
        {
            Row -Label $node
        }

        foreach ( $node in $results )
        {
            [void]$tableData.Add($node)
        }
    }
    end
    {
        $html = '<TABLE CELLBORDER="1" BORDER="0" CELLSPACING="0"><TR><TD bgcolor="black" align="center"><font color="white"><B>{0}</B></font></TD></TR>{1}</TABLE>' -f $Label, ($tableData -join '')
        Node $Name @{label = $html; shape = 'none'; fontname = "Courier New"; style = "filled"; penwidth = 1; fillcolor = "white"}
    }
}

