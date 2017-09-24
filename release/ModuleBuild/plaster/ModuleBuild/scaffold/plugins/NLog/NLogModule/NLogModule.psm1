## Pre-Loaded Module code ##

<#
 Put all code that must be run prior to function dot sourcing here.

 This is a good place for module variables as well. The only rule is that no 
 variable should rely upon any of the functions in your module as they 
 will not have been loaded yet. Also, this file cannot be completely
 empty. Even leaving this comment is good enough.
#>

## PRIVATE MODULE FUNCTIONS AND DATA ##

function Get-CallerPreference {
    <#
    .Synopsis
       Fetches "Preference" variable values from the caller's scope.
    .DESCRIPTION
       Script module functions do not automatically inherit their caller's variables, but they can be
       obtained through the $PSCmdlet variable in Advanced Functions.  This function is a helper function
       for any script module Advanced Function; by passing in the values of $ExecutionContext.SessionState
       and $PSCmdlet, Get-CallerPreference will set the caller's preference variables locally.
    .PARAMETER Cmdlet
       The $PSCmdlet object from a script module Advanced Function.
    .PARAMETER SessionState
       The $ExecutionContext.SessionState object from a script module Advanced Function.  This is how the
       Get-CallerPreference function sets variables in its callers' scope, even if that caller is in a different
       script module.
    .PARAMETER Name
       Optional array of parameter names to retrieve from the caller's scope.  Default is to retrieve all
       Preference variables as defined in the about_Preference_Variables help file (as of PowerShell 4.0)
       This parameter may also specify names of variables that are not in the about_Preference_Variables
       help file, and the function will retrieve and set those as well.
    .EXAMPLE
       Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

       Imports the default PowerShell preference variables from the caller into the local scope.
    .EXAMPLE
       Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -Name 'ErrorActionPreference','SomeOtherVariable'

       Imports only the ErrorActionPreference and SomeOtherVariable variables into the local scope.
    .EXAMPLE
       'ErrorActionPreference','SomeOtherVariable' | Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

       Same as Example 2, but sends variable names to the Name parameter via pipeline input.
    .INPUTS
       String
    .OUTPUTS
       None.  This function does not produce pipeline output.
    .LINK
       about_Preference_Variables
    #>

    [CmdletBinding(DefaultParameterSetName = 'AllVariables')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_.GetType().FullName -eq 'System.Management.Automation.PSScriptCmdlet' })]
        $Cmdlet,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.SessionState]$SessionState,

        [Parameter(ParameterSetName = 'Filtered', ValueFromPipeline = $true)]
        [string[]]$Name
    )

    begin {
        $filterHash = @{}
    }
    
    process {
        if ($null -ne $Name)
        {
            foreach ($string in $Name)
            {
                $filterHash[$string] = $true
            }
        }
    }

    end {
        # List of preference variables taken from the about_Preference_Variables help file in PowerShell version 4.0

        $vars = @{
            'ErrorView' = $null
            'FormatEnumerationLimit' = $null
            'LogCommandHealthEvent' = $null
            'LogCommandLifecycleEvent' = $null
            'LogEngineHealthEvent' = $null
            'LogEngineLifecycleEvent' = $null
            'LogProviderHealthEvent' = $null
            'LogProviderLifecycleEvent' = $null
            'MaximumAliasCount' = $null
            'MaximumDriveCount' = $null
            'MaximumErrorCount' = $null
            'MaximumFunctionCount' = $null
            'MaximumHistoryCount' = $null
            'MaximumVariableCount' = $null
            'OFS' = $null
            'OutputEncoding' = $null
            'ProgressPreference' = $null
            'PSDefaultParameterValues' = $null
            'PSEmailServer' = $null
            'PSModuleAutoLoadingPreference' = $null
            'PSSessionApplicationName' = $null
            'PSSessionConfigurationName' = $null
            'PSSessionOption' = $null

            'ErrorActionPreference' = 'ErrorAction'
            'DebugPreference' = 'Debug'
            'ConfirmPreference' = 'Confirm'
            'WhatIfPreference' = 'WhatIf'
            'VerbosePreference' = 'Verbose'
            'WarningPreference' = 'WarningAction'
        }

        foreach ($entry in $vars.GetEnumerator()) {
            if (([string]::IsNullOrEmpty($entry.Value) -or -not $Cmdlet.MyInvocation.BoundParameters.ContainsKey($entry.Value)) -and
                ($PSCmdlet.ParameterSetName -eq 'AllVariables' -or $filterHash.ContainsKey($entry.Name))) {
                
                $variable = $Cmdlet.SessionState.PSVariable.Get($entry.Key)
                
                if ($null -ne $variable) {
                    if ($SessionState -eq $ExecutionContext.SessionState) {
                        Set-Variable -Scope 1 -Name $variable.Name -Value $variable.Value -Force -Confirm:$false -WhatIf:$false
                    }
                    else {
                        $SessionState.PSVariable.Set($variable.Name, $variable.Value)
                    }
                }
            }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Filtered') {
            foreach ($varName in $filterHash.Keys) {
                if (-not $vars.ContainsKey($varName)) {
                    $variable = $Cmdlet.SessionState.PSVariable.Get($varName)
                
                    if ($null -ne $variable)
                    {
                        if ($SessionState -eq $ExecutionContext.SessionState)
                        {
                            Set-Variable -Scope 1 -Name $variable.Name -Value $variable.Value -Force -Confirm:$false -WhatIf:$false
                        }
                        else
                        {
                            $SessionState.PSVariable.Set($variable.Name, $variable.Value)
                        }
                    }
                }
            }
        }
    }
}

function Remove-NLogDLL
{
    <#
    .SYNOPSIS
        Unload the NLog dlls from memory.        
    .DESCRIPTION
        Unload the NLog dlls from memory.
    .EXAMPLE
        Remove-NLogDLL
    #>
    if ( Get-NLogDllLoadState ) {
        try {
            get-module | where {($_.Name -eq 'nlog') -or ($_.Name -eq 'Nlog45')} | foreach {
                Write-Host "Removing Nested Module $($_.Name)"
                Remove-Module $_
            }
        }
        catch { 
            Write-Warning "Unable to uninitialize module."
        }
    }
}


## PUBLIC MODULE FUNCTIONS AND DATA ##

function Get-LogMessageLayout {
    <#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/Get-LogMessageLayout.md
    #>
    [CmdletBinding()]
    param (
        [parameter()] 
        [System.Int32]$layoutId = 1
    ) 
    
    switch ($layoutId) {
        1 {
            $layout    = '${longdate} | ${machinename} | ${processid} | ${processname} | ${level} | ${logger} | ${message}'
        }
        default {
            $layout    = '${longdate} | ${machinename} | ${processid} | ${processname} | ${level} | ${logger} | ${message}'
        }
    }
    return $layout
}



function Get-NewLogConfig {
    <#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/Get-NewLogConfig.md
    #>
    New-Object NLog.Config.LoggingConfiguration 
}



function Get-NewLogger {
    <#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/Get-NewLogger.md
    #>
    param (
        [parameter(mandatory=$true)] 
        [System.String]$LoggerName
    ) 
    
    [NLog.LogManager]::GetLogger($loggerName) 
}



function Get-NewLogTarget {
    <#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/Get-NewLogTarget.md
    #>
    param (
        [parameter(mandatory=$true)]
        [System.String]$TargetType ) 
    
    switch ($TargetType) {
        "console" {
            New-Object NLog.Targets.ColoredConsoleTarget    
        }
        "file" {
            New-Object NLog.Targets.FileTarget
        }
        "mail" { 
            New-Object NLog.Targets.MailTarget
        }
    }

}



function Get-NLogDllLoadState {
    <#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/Get-NLogDllLoadState.md
    #>
    if (-not (get-module | where {($_.Name -eq 'nlog') -or ($_.Name -eq 'Nlog45')})) {
        return $false
    }
    else {
        return $true
    }
}



function Register-NLog {
    <#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/Register-NLog.md
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [string]$FileName,
        [Parameter()]
        [string]$LoggerName = 'TestLogger'
        
    )
    if ($Script:Logger -eq $null) {
        $debugLog                      = Get-NewLogTarget -targetType "file"
        $debugLog.ArchiveAboveSize     = 10240000
        $debugLog.archiveEvery         = "Month"
        $debugLog.ArchiveNumbering     = "Rolling"    
        $debugLog.CreateDirs           = $true    
        $debugLog.FileName             = $FileName
        $debugLog.Encoding             = [System.Text.Encoding]::GetEncoding("iso-8859-2")
        $debugLog.KeepFileOpen         = $false
        $debugLog.Layout               = Get-LogMessageLayout -layoutId 1    
        $debugLog.maxArchiveFiles      = 1
        
        $Script:NLogConfig.AddTarget("file", $debugLog)
        
        $rule1 = New-Object NLog.Config.LoggingRule("*", [NLog.LogLevel]::Debug, $debugLog)
        $Script:NLogConfig.LoggingRules.Add($rule1)

        # Assign configured Log config to LogManager
        [NLog.LogManager]::Configuration = $Script:NLogConfig

        # Create a new Logger
        $Script:Logger = Get-NewLogger -loggerName $LoggerName
    }
    else {
        Write-Warning 'NlogModule: You must first run UnRegister-NLog!'
    }
}



function UnRegister-NLog {
        <#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/UnRegister-NLog.md
    #>
    [CmdletBinding()]
    param ()
    if ($Script:Logger -ne $null) {
        $Script:NLogConfig = Get-NewLogConfig
        $Script:Logger = $null
    }
    else {
        Write-Host 'NlogModule: You must first run Register-NLog!'
    }
}



function Write-Debug {
<#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/Write-Debug.md
    #>


    [CmdletBinding(HelpUri='http://go.microsoft.com/fwlink/?LinkID=113424', RemotingCapability='None')]
     param(
         [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
         [Alias('Msg')]
         [AllowEmptyString()]
         [string]
         ${Message})
     
     begin
     {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
         try {
             $outBuffer = $null
             if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
             {
                 $PSBoundParameters['OutBuffer'] = 1
             }
             $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Debug', [System.Management.Automation.CommandTypes]::Cmdlet)
             $scriptCmd = {& $wrappedCmd @PSBoundParameters }
             $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
             $steppablePipeline.Begin($PSCmdlet)
         } catch {
             throw
         }
     }
     
     process
     {
         try {
             $steppablePipeline.Process($_)
         } catch {
             throw
         }
     }
     
     end
     {
        if ($script:Logger -ne $null) {
            $script:Logger.Trace($Message)
        }
         try {
             $steppablePipeline.End()
         } catch {
             throw
         }
     }
}



function Write-Error {
<#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/Write-Error.md
    #>


    [CmdletBinding(DefaultParameterSetName='NoException', RemotingCapability='None')]
     param(
         [Parameter(ParameterSetName='WithException', Mandatory=$true)]
         [System.Exception]
         ${Exception},
     
         [Parameter(ParameterSetName='NoException', Mandatory=$true, Position=0, ValueFromPipeline=$true)]
         [Parameter(ParameterSetName='WithException')]
         [Alias('Msg')]
         [AllowEmptyString()]
         [AllowNull()]
         [string]
         ${Message},
     
         [Parameter(ParameterSetName='ErrorRecord', Mandatory=$true)]
         [System.Management.Automation.ErrorRecord]
         ${ErrorRecord},
     
         [Parameter(ParameterSetName='WithException')]
         [Parameter(ParameterSetName='NoException')]
         [System.Management.Automation.ErrorCategory]
         ${Category},
     
         [Parameter(ParameterSetName='NoException')]
         [Parameter(ParameterSetName='WithException')]
         [string]
         ${ErrorId},
     
         [Parameter(ParameterSetName='NoException')]
         [Parameter(ParameterSetName='WithException')]
         [System.Object]
         ${TargetObject},
     
         [string]
         ${RecommendedAction},
     
         [Alias('Activity')]
         [string]
         ${CategoryActivity},
     
         [Alias('Reason')]
         [string]
         ${CategoryReason},
     
         [Alias('TargetName')]
         [string]
         ${CategoryTargetName},
     
         [Alias('TargetType')]
         [string]
         ${CategoryTargetType})
     
     begin
     {
         try {
             $outBuffer = $null
             if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
             {
                 $PSBoundParameters['OutBuffer'] = 1
             }
             $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Error', [System.Management.Automation.CommandTypes]::Cmdlet)
             $scriptCmd = {& $wrappedCmd @PSBoundParameters }
             $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
             $steppablePipeline.Begin($PSCmdlet)
         } catch {
             throw
         }
     }
     
     process
     {
         try {
             $steppablePipeline.Process($_)
         } catch {
             throw
         }
     }
     
     end
     {
        if ($script:Logger -ne $null) {
            $script:Logger.Error($Message)
        }
        try {
            $steppablePipeline.End()
        } catch {
            throw
        }
     }
}



function Write-Host {
<#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/Write-Host.md
    #>


    [CmdletBinding(HelpUri='http://go.microsoft.com/fwlink/?LinkID=113426', RemotingCapability='None')]
     param(
         [Parameter(Position=0, ValueFromPipeline=$true, ValueFromRemainingArguments=$true)]
         [System.Object]
         ${Object},
     
         [switch]
         ${NoNewline},
     
         [System.Object]
         ${Separator},
     
         [System.ConsoleColor]
         ${ForegroundColor},
     
         [System.ConsoleColor]
         ${BackgroundColor})
     
     begin
     {
         try {
             $outBuffer = $null
             if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
             {
                 $PSBoundParameters['OutBuffer'] = 1
             }
             $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Host', [System.Management.Automation.CommandTypes]::Cmdlet)
             $scriptCmd = {& $wrappedCmd @PSBoundParameters }
             $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
             $steppablePipeline.Begin($PSCmdlet)
         } catch {
             throw
         }
     }
     
     process
     {
         try {
             $steppablePipeline.Process($_)
         } catch {
             throw
         }
     }
     
     end
     {
        if ($script:Logger -ne $null) {
            $Message = [string]$Object
            $script:Logger.Info("$Message")
        }
         try {
             $steppablePipeline.End()
         } catch {
             throw
         }
     }
}



function Write-Output {
<#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/Write-Output.md
    #>
    [CmdletBinding(HelpUri='http://go.microsoft.com/fwlink/?LinkID=113427', RemotingCapability='None')]
     param(
         [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromRemainingArguments=$true)]
         [AllowEmptyCollection()]
         [AllowNull()]
         [psobject[]]${InputObject},
         [switch]${NoEnumerate})
     
     begin
     {
         try {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
             $outBuffer = $null
             if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
             {
                 $PSBoundParameters['OutBuffer'] = 1
             }
             $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Output', [System.Management.Automation.CommandTypes]::Cmdlet)
             $scriptCmd = {& $wrappedCmd @PSBoundParameters }
             $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
             $steppablePipeline.Begin($PSCmdlet)
         } catch {
             throw
         }
     }
     
     process
     {
         try {
             $steppablePipeline.Process($_)
         } catch {
             throw
         }
     }
     
     end
     {
        if ($script:Logger -ne $null) {
            $OutputMessage = [string]$InputObject
            $script:Logger.Info("$OutputMessage")
        }
         try {
             $steppablePipeline.End()
         } catch {
             throw
         }

     }
}



function Write-Verbose {
<#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/Write-Verbose.md
    #>


    [CmdletBinding(HelpUri='http://go.microsoft.com/fwlink/?LinkID=113429', RemotingCapability='None')]
     param(
         [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
         [Alias('Msg')]
         [AllowEmptyString()]
         [string]
         ${Message})
     
    begin
    {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
         try {
             $outBuffer = $null
             if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
             {
                 $PSBoundParameters['OutBuffer'] = 1
             }
             $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Verbose', [System.Management.Automation.CommandTypes]::Cmdlet)
             $scriptCmd = {& $wrappedCmd @PSBoundParameters }
             $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
             $steppablePipeline.Begin($PSCmdlet)
         } catch {
             throw
         }
     }
     
     process
     {
         try {
             $steppablePipeline.Process($_)
         } catch {
             throw
         }
     }
     
     end
     {
        if ($script:Logger -ne $null) {
            $script:Logger.Info("$Message")
        }
         try {
             $steppablePipeline.End()
         } catch {
             throw
         }
     }
}



function Write-Warning {
<#
    .EXTERNALHELP NLogModule-help.xml
    .LINK
        https://github.com/zloeber/nlogmodule/tree/master/release/0.0.1/docs/Functions/Write-Warning.md
    #>


    [CmdletBinding(HelpUri='http://go.microsoft.com/fwlink/?LinkID=113430', RemotingCapability='None')]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [Alias('Msg')]
        [AllowEmptyString()]
        [string]${Message}
    )
     
    begin
    {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer)) {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Warning', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        } 
        catch {
            throw
        }
    }
     
    process
    {
        try {
            $steppablePipeline.Process($_)
        }
        catch {
            throw
        }
    }
     
    end {
        if ($script:Logger -ne $null) {
            $script:Logger.Warn("$Message")
        }
        try {
            $steppablePipeline.End()
        }
        catch {
            throw
        }
    }
}



## Post-Load Module code ##


# Use this variable for any path-sepecific actions (like loading dlls and such) to ensure it will work in testing and after being built
$MyModulePath = $(
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

    Get-ScriptPath
)

#region Module Cleanup
$ExecutionContext.SessionState.Module.OnRemove = {
    # Action to take if the module is removed
}

$null = Register-EngineEvent -SourceIdentifier ( [System.Management.Automation.PsEngineEvent]::Exiting ) -Action {
    # Action to take if the whole pssession is killed
}

# Use this in your scripts to check if the function is being called from your module or independantly.
$ThisModuleLoaded = $true

try {
    $DotNetInstalled = (Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse | 
        Get-ItemProperty -name Version -ea 0 | 
        Where { $_.PSChildName -match '^(?!S)\p{L}'} | 
        Select @{n='version';e={[decimal](($_.Version).Substring(0,3))}} -Unique |
        Sort-Object -Descending | select -First 1).Version
}
catch {
    $DotNetInstalled = 3.5
}

if ($DotNetInstalled -ge 4.5) {
    #$__dllPath = Join-Path -Path $MyInvocation.MyCommand.ScriptBlock.Module.ModuleBase -ChildPath "$($Script:ScriptPath)/lib/Nlog45.dll"
    $__dllPath = "$($MyModulePath)\lib\Nlog45.dll"
}
else {
    #$__dllPath = Join-Path -Path $MyInvocation.MyCommand.ScriptBlock.Module.ModuleBase -ChildPath "$($Script:ScriptPath)/lib/Nlog.dll"
    $__dllPath = "$($MyModulePath)\lib\Nlog.dll"
}

try {
    #Write-Host "Attempting to import $($__dllPath)..."
    Import-Module -Name $__dllPath -ErrorAction Stop
}
catch {
    throw
}

$Logger = $null
$NLogConfig = Get-NewLogConfig

#region Module Cleanup
$ExecutionContext.SessionState.Module.OnRemove = {Remove-NLogDLL} 
$null = Register-EngineEvent -SourceIdentifier ( [System.Management.Automation.PsEngineEvent]::Exiting ) -Action {Remove-NLogDLL}
#endregion Module Cleanup

# Exported members
Export-ModuleMember -Variable NLogConfig -Function  'Get-LogMessageLayout', 'Get-NewLogConfig', 'Get-NewLogger', 'Get-NewLogTarget', 'Get-NLogDllLoadState', 'Register-NLog', 'UnRegister-NLog', 'Write-Debug', 'Write-Error', 'Write-Host', 'Write-Output', 'Write-Verbose', 'Write-Warning'



