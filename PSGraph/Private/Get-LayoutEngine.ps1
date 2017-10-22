function Get-LayoutEngine( $name )
{
    $layoutEngine = @{
        Hierarchical      = 'dot'
        SpringModelSmall  = 'neato'
        SpringModelMedium = 'fdp'
        SpringModelLarge  = 'sfdp'
        Radial            = 'twopi'
        Circular          = 'circo'
        dot               = 'dot'
        neato             = 'neato'
        fdp               = 'fdp'
        sfdp              = 'sfdp'
        twopi             = 'twopi'
        circo             = 'circo'
    }

    return $layoutEngine[$name]
}
