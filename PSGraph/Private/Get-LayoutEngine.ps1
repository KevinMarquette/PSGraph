function Get-LayoutEngine($name)
{
    $layoutEngine = @{
        Hierarchical      = 'dot'
        SpringModelSmall  = 'neato'
        SpringModelMedium = 'fdp'
        SpringModelLarge  = 'sfdp'
        Radial            = 'twopi'
        Circular          = 'circo'
    }

    return $layoutEngine[$name]
}
