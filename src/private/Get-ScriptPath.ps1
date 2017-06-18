Function Get-ScriptPath {
        $Invocation = (Get-Variable MyInvocation -Scope 1).Value
        if($Invocation.PSScriptRoot) {
            $Invocation.PSScriptRoot
        }
        Elseif($Invocation.MyCommand.Path) {
            Split-Path $Invocation.MyCommand.Path
        }
        elseif ($Invocation.InvocationName.Length -eq 0) {
            (Get-Location).Path
        }
        else {
            $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf("\"));
        }
    }
