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
    [cmdletbinding()]
    param(
        # The Scriptblock used to process every node value
        [ScriptBlock]
        $ScriptBlock = {$_}
    )
    $Script:CustomFormat = $ScriptBlock
}