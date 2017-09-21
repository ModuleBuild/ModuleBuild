<#
 Put all code that must be run prior to function dot sourcing here.

 This is a good place for module variables as well. The only rule is that no
 variable should rely upon any of the functions in your module as they
 will not have been loaded yet. Also, this file cannot be completely
 empty. Even leaving this comment is good enough.
#>

$PrivateFunctionTemplate = @'
function %%FunctionName%% {
    <#
    .SYNOPSIS
    TBD
    .DESCRIPTION
    TBD
    .LINK
    https://github.com/zloeber/ModuleBuild
    .EXAMPLE
    TBD
    .NOTES
    Author: %%ModuleAuthor%%
    Website: %%ModuleWebsite%%
    #>

    [CmdletBinding()]
    param(
    )
    begin {
        if ($script:ThisModuleLoaded -eq $true) {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        }
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Verbose "$($FunctionName): Begin."
    }
    process {
    }
    end {
        Write-Verbose "$($FunctionName): End."
    }
}
'@