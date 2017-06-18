function Get-ParentASTTypes {
    <#
    .SYNOPSIS
        Retrieves all parent types of a given AST element.
    .DESCRIPTION
        
    .PARAMETER Code
        Multiline or piped lines of code to process.
    .EXAMPLE
       
       Description
       -----------

    .NOTES
       Author: Zachary Loeber
       Site: http://www.the-little-things.net/
       Requires: Powershell 3.0

       Version History
       1.0.0 - Initial release
    #>
    [CmdletBinding()]
    param(
        [parameter(Position = 0, Mandatory = $true, ValueFromPipeline=$true, HelpMessage='AST element to process.')]
        $AST
    )
    # Pull in all the caller verbose,debug,info,warn and other preferences
    if ($script:ThisModuleLoaded -eq $true) { Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState }
    $FunctionName = $MyInvocation.MyCommand.Name
    Write-Verbose "$($FunctionName): Begin."
    $ASTParents = @()
    if ($AST.Parent -ne $null) {
        $CurrentParent = $AST.Parent
        $KeepProcessing = $true
    }
    else {
        $KeepProcessing = $false
    }
    while ($KeepProcessing) {
        $ASTParents += $CurrentParent.GetType().Name.ToString()
        if ($CurrentParent.Parent -ne $null) {
            $CurrentParent = $CurrentParent.Parent
            $KeepProcessing = $true
        }
        else {
            $KeepProcessing = $false
        }
    }

    $ASTParents
    Write-Verbose "$($FunctionName): End."
}