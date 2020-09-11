Function New-EdgeAttributeSet {
    <#
      .synopsis
        Creates a set of attributes for the node command.
      .description
        The node commands take a hash table of attributes, but it can be a memory and typing test to write it.
        Names are case sensitive so specifying blue works but Blue fails,
        Is the font name "courier New", "Courier new" or "Courier_New" ? Is the direction "back or backward"
        This function uses argument completers to fill in as many of the parameters as possible and converts
        values to lower case where needed.
      .example
      $edgeattr = New-EdgeAttr ibuteSet -direction both -arrowhead 'crow' -arrowtail  'lcrow' -color blue -fontname 'Calibri' -label "test"  -style dashed
      This defines a two way dashed arrow, in blue with a "crow" head and left-half-crow tail, with "test" as in black calibri as the style
      Note that the argument completer will help arrows in line with the grammar at http://www.graphviz.org/doc/info/arrows.html,
      only 42 of the 60 possible permuations are valid, and it allows double arrows but doesn't check for a redundant "none" in the sytle
    #>
    [CmdletBinding()]
    [Alias('EdgeAttributes')]
    Param(
        #Style of arrowhead on the head node of an edge. This will only appear if the dir attribute is "forward" or "both".
        [string]
        $arrowhead,
        #Multiplicative scale factor for arrowheads
        [double]
        $arrowsize,
        #Style of arrowhead on the tail node of an edge. This will only appear if the dir attribute is "back" or "both"
        [string]
        $arrowtail,
        #Basic drawing color for graphics, not text (which requires font color to be set)
        [string]
        $color,
        #If false, the edge is not used in ranking the nodes (defaults to true)
        [bool]
        $constraint,
        #Indicates which ends of the edge should be decorated with an arrowhead.
        [ValidateSet('forward','back','both','none')]
        [String]
        $direction,
        [string]
        #Color used for text.
        $fontcolor,
        #Font used for text.
        [string]
        $fontname,
        #Font size, in points, used for text.
        [double]
        $fontsize,
        #Text label to be placed near head of edge
        [string]
        $headlabel,
        #Text label attached to the edge
        [string]
        $label,
        #Color used for headlabel and taillabel. If not set, defaults to edge's fontcolor.
        [string]
        $labelfontcolor,
        #Font used for headlabel and taillabel. If not set, defaults to edge's fontname.
        [string]
        $labelfontname,
        #Font size, in points, used for headlabel and taillabel. If not set, defaults to edge's fontsize.
        [double]
        $labelfontsize,
        #Preferred edge length, in inches.
        [double]
        $length,
        #width of the pen, in points, used to draw lines and curves, including the boundaries of edges. It has no effect on text.
        [double]
        $penwidth,
        #Style for the edge, dashed, solid etc.
        [ValidateSet("dashed", "dotted", "solid", "invis", "bold" , "tapered")]
        [String]
        $style,
        #Text label to be placed near tail of edge.
        [string]
        $taillabel
    )
    $values = @{}
    #Attributes where name is shortened and doesn't match the parameter name
    if ($direction) {$values['dir'] = $direction.ToLower()}
    if ($length)    {$values['len'] = $length}
    #Attributes where graphviz expects all lower case and other case might have got through
    foreach ($param in @( 'arrowhead', 'arrowtail', 'color', 'fontcolor', 'labelfontcolor','style')) {
        if ($PSBoundParameters[$param]) {$values[$param] = $PSBoundParameters[$param].ToLower() }
    }
    #Attributes that can go through unchanged.
    foreach ($param in @( 'arrowsize', 'constraint', 'fontname',  'fontsize', 'headlabel',
                         'label', 'labelfontname', 'labelfontsize', 'penwidth', 'taillabel')) {
        if ($PSBoundParameters[$param]) {$values[$param] = $PSBoundParameters[$param].ToLower() }
    }

    $values
}

