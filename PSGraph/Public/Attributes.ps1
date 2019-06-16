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


Function New-NodeAttributeSet {
    <#
      .synopsis
        Creates a set of attributes for the edge command.
      .description
        The edge commands takes a hash table of attributes, but it can be a memory and typing test to write it.
        Names are case sensitive so specifying blue works but Blue fails,
        Is the font name "courier New", "Courier new" or "Courier_New" ? Is the direction "back or backward"
        This function uses argument completers to fill in as many of the parameters as possible and converts
        values to lower case where needed.
      .example
      $edgeattr = New-EdgeAttributeSet -direction both -arrowhead 'crow' -arrowtail  'lcrow' -color blue -fontname 'Calibri' -label "test"  -style dashed
      This defines a two way dashed arrow, in blue with a "crow" head and left-half-crow tail, with "test" as in black calibri as the style
      Note that the argument completer will help arrows in line with the grammar at http://www.graphviz.org/doc/info/arrows.html,
      only 42 of the 60 possible permuations are valid, and it allows double arrows but doesn't check for a redundant "none" in the sytle
    #>
    [CmdletBinding()]
    [Alias('NodeAttributes')]
    Param(
        #Basic drawing color for graphics, not text (which requires font color to be set)
        [string]
        $color,
        #Distortion factor for shape=polygon. Positive values cause top part to be larger than bottom; negative values do the opposite.
        [double]
        $distortion,
        [string]
        $fillcolor,
        #If true, the node size is specified by the values of the width and height attributes only and is not expanded to contain the text label.
        #If the fixedsize attribute is set to shape, the width and height attributes also determine the size of the node shape, but the label can be much larger.
        [ValidateSet('false','shape','true')]
        [string]
        $fixedSize,
        #Color used for text.
        $fontcolor,
        #Font used for text.
        [string]
        $fontname,
        #Font size, in points, used for text.
        [double]
        $fontsize,
        #Height of node, in inches. This is taken as the initial, minimum height of the node
        $height,
        #Gives the name of a file containing an image to be displayed inside a node. The image file must be in one of the recognized formats, typically JPEG, PNG, GIF, BMP, SVG or Postscript, and be able to be converted into the desired output format.
        [string]
        $image,
        #Text label attached to the node
        [string]
        $label,
        #width of the pen, in points, used to draw lines and curves.
        [double]
        $penwidth,
        # force polygon to be regular, i.e., the vertices of the polygon will lie on a circle whose center is the center of the node.
        [switch]
        $regular,
        #Number of sides if shape=polygon.
        #A string specifying the shape of a node.
        [ValidateSet('box', 'polygon', 'ellipse', 'oval', 'circle', 'point', 'egg', 'triangle', 'plaintext', 'plain', 'diamond',
            'trapezium', 'parallelogram', 'house', 'pentagon', 'hexagon', 'septagon', 'octagon', 'doublecircle',
            'doubleoctagon', 'tripleoctagon', 'invtriangle', 'invtrapezium', 'invhouse', 'Mdiamond', 'Msquare',
            'Mcircle', 'rect', 'rectangle', 'square', 'star', 'none', 'underline', 'cylinder', 'note', 'tab',
            'folder', 'box3d', 'component', 'promoter', 'cds', 'terminator', 'utr', 'primersite', 'restrictionsite',
            'fivepoverhang', 'threepoverhang', 'noverhang', 'assembly', 'signature', 'insulator', 'ribosite',
            'rnastab', 'proteasesite', 'proteinstab', 'rpromoter', 'rarrow', 'larrow', 'lpromoter')]
        [string]
        $Shape,[int16]
        $sides,
        #Skew factor for shape=polygon. Positive values skew top of polygon to right; negative to left.
        [double]
        $skew,
        #Style for the edge, dashed, solid etc.
        [ValidateSet("dashed", "dotted", "solid", "invis", "bold" , "filled", "striped", "wedged", "diagonals", "rounded")]
        [String]
        $style,

        #Width of node, in inches. This is taken as the initial, minimum width of the node.
        [double]
        $width
    )
    $values = @{}
    #Attributes where name is shortened and doesn't match the parameter name
    if ($regular)   {$values['regular'] = $true}
    #Attributes where graphviz expects all lower case and other case might have got through
    foreach ($param in @( 'color', 'fillcolor', 'fixedsize', 'fontcolor', 'shape', 'style')) {
        if ($PSBoundParameters[$param]) {$values[$param] = $PSBoundParameters[$param].ToLower() }
    }
    #Attributes that can go through unchanged.
    foreach ($param in @( ' $distortion', 'fontname',  'fontsize', 'height', 'image',
                         'label', 'penwidth', 'sides', 'skew')) {
        if ($PSBoundParameters[$param]) {$values[$param] = $PSBoundParameters[$param].ToLower() }
    }

    $values
}

function arrowStyles {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    $baseArrows = @('box', 'crow', 'curve', 'diamond', 'dot', 'inv', 'none', 'normal', 'tee', 'vee')
    $doubleArrowRegex =  "^[olr]*(" + ($basearrows -join "|") + ")[olr]*(?=\w+)"
    if ($wordToComplete -match $doubleArrowRegex) {
       $arrows = foreach ($a in $baseArrows ) {$Matches[0] + $a}
    }
    elseif ($wordToComplete -match '^ol|^or|^o|^l|^r' ) {
        $arrows = foreach ($a in $baseArrows ) {$Matches[0] + $a}
    }
    else {$arrows = $baseArrows}
    $arrows.Where({$_ -like "$wordToComplete*"}) | ForEach-Object {
        New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList "'$_'" , $_ ,
        ([System.Management.Automation.CompletionResultType]::ParameterValue) , $_
    }
}

function ColorCompletion {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    [System.Drawing.KnownColor].GetFields() | Where-Object {$_.IsStatic -and -not $_.IsSpecialName -and $_.name -like "$wordToComplete*" } |
        Sort-Object name | ForEach-Object {New-CompletionResult $_.name.ToLower() $_.name.ToLower()
    }
}

function ListFonts {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    if (-not $script:FontFamilies) {
        $script:FontFamilies = @("","")
        try {
            $script:FontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name
        }
        catch {}
    }
    $script:FontFamilies.where({$_ -Gt "" -and $_ -like "$wordToComplete*"} ) | ForEach-Object {
        New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList "'$_'" , $_ ,
        ([System.Management.Automation.CompletionResultType]::ParameterValue) , $_
    }
}

if (Get-Command -Name register-argumentCompleter -ErrorAction SilentlyContinue) {
    Register-ArgumentCompleter -CommandName New-EdgeAttributeSet              -ParameterName arrowhead      -ScriptBlock $Function:arrowStyles
    Register-ArgumentCompleter -CommandName New-EdgeAttributeSet              -ParameterName arrowtail      -ScriptBlock $Function:arrowStyles
    Register-ArgumentCompleter -CommandName New-EdgeAttributeSet              -ParameterName color          -ScriptBlock $Function:ColorCompletion
    Register-ArgumentCompleter -CommandName New-EdgeAttributeSet              -ParameterName fontcolor      -ScriptBlock $Function:ColorCompletion
    Register-ArgumentCompleter -CommandName New-EdgeAttributeSet              -ParameterName labelfontcolor -ScriptBlock $Function:ColorCompletion
    Register-ArgumentCompleter -CommandName New-EdgeAttributeSet              -ParameterName labelfontname  -ScriptBlock $Function:ListFonts
    Register-ArgumentCompleter -CommandName New-EdgeAttributeSet              -ParameterName fontname       -ScriptBlock $Function:ListFonts
    Register-ArgumentCompleter -CommandName New-NodeAttributeSet              -ParameterName fontname       -ScriptBlock $Function:ListFonts
    Register-ArgumentCompleter -CommandName New-NodeAttributeSet              -ParameterName fontcolor      -ScriptBlock $Function:ColorCompletion
    Register-ArgumentCompleter -CommandName New-NodeAttributeSet              -ParameterName fillcolor      -ScriptBlock $Function:ColorCompletion
    Register-ArgumentCompleter -CommandName New-NodeAttributeSet              -ParameterName color          -ScriptBlock $Function:ColorCompletion

}