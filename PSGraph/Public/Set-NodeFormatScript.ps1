function Set-NodeFormatScript
{
    <#
        .Description
        Allows the definition of a custom node format

        .Example
        Set-NodeFormatScript -ScriptBlock {$_.ToLower()}

        .Notes
        This can be used if different datasets are not consistent.
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        
        # The Scriptblock used to process every node value
        [ScriptBlock]
        $ScriptBlock = {$_}
    )
    
    if($PSCmdlet.ShouldProcess('Change default code id format function'))
    {
        $Script:CustomFormat = $ScriptBlock
    }
   
}
