## Pre-Loaded Module code ##

<#
 Put all code that must be run prior to function dot sourcing here.

 This is a good place for module variables as well. The only rule is that no 
 variable should rely upon any of the functions in your module as they 
 will not have been loaded yet. Also, this file cannot be completely
 empty. Even leaving this comment is good enough.
#>

## PRIVATE MODULE FUNCTIONS AND DATA ##

function Convert-ArrayToRegex {
    # Takes an array of strings and turns it into a regex matchable string
    [CmdletBinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [String[]]$Item,
        [parameter(Position = 1)]
        [Switch]$DoNotEscape
    )
    begin {
        $Items = @()
    }
    process {
        $Items += $Item
    }
    end {
        if ($Items.Count -gt 0) {
            if ($DoNotEscape) {
                '^(' + ($Items -join '|') + ')$'
            }
            else {
                '^(' + (($Items | %{[regex]::Escape($_)}) -join '|') + ')$'
            }
        }
        else {
            '^()$'
        }
    }
}

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

function Get-CommonParameters {
    # Helper function to get all the automatically added parameters in an
    # advanced function
    function somefunct {
        [CmdletBinding(SupportsShouldProcess = $true, SupportsPaging = $true, SupportsTransactions = $true)]
        param()
    }

    ((Get-Command somefunct).Parameters).Keys
}

function Get-Function {
    <#
    .SYNOPSIS
        Enumerates all functions within lines of code.
    .DESCRIPTION
        Enumerates all functions within lines of code.
    .PARAMETER Code
        Multiline or piped lines of code to process.
    .PARAMETER Name
        Name of a function to return. Default is all functions.
    .EXAMPLE
        TBD
    .NOTES
       Author: Zachary Loeber
       Site: http://www.the-little-things.net/
       Requires: Powershell 3.0

       Version History
       1.0.0 - Initial release
    .LINK
        http://www.the-little-things.net
    #>
    [CmdletBinding()]
    param(
        [parameter(Position = 0, Mandatory = $true, ValueFromPipeline=$true, HelpMessage='Lines of code to process.')]
        [AllowEmptyString()]
        [string[]]$Code,
        [parameter(Position=1, HelpMessage='Name of function to process.')]
        [string]$Name = '*'
    )
    begin {
        $ThisFunc = $MyInvocation.MyCommand.Name
        Write-Verbose "$($ThisFunc): Begin."

        $Codeblock = @()
        $ParseError = $null
        $Tokens = $null

        $predicate = {
            ($args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]) -and
            ($args[0].Name -like $name)
        }
    }
    process {
        $Codeblock += $Code
    }
    end {
        $ScriptText = ($Codeblock | Out-String).trim("`r`n")
        Write-Verbose "$($ThisFunc): Attempting to parse AST."
        $AST = [System.Management.Automation.Language.Parser]::ParseInput($ScriptText, [ref]$Tokens, [ref]$ParseError)

        if($ParseError) {
            throw "$($ThisFunc): Will not work properly with errors in the script, please modify based on the above errors and retry."
        }

        # First get all blocks
        $Blocks = $AST.FindAll($predicate, $true)

        Foreach ($Block in $Blocks) {
            $FunctionProps = @{
                Name = $Block.Name
                Definition = $Block.Extent.Text
                IsEmbedded = $false
                AST = $Block
            }

            if (@(Get-ParentASTTypes $Block) -contains 'FunctionDefinitionAst') {
                $FunctionProps.IsEmbedded = $true
            }

            New-Object -TypeName psobject -Property $FunctionProps
        }

        Write-Verbose "$($ThisFunc): End."
    }
}

function Get-FunctionParameter {
    <#
    .SYNOPSIS
    Return all parameters for each function found in a code block.
    .DESCRIPTION
    Return all parameters for each function found in a code block.
    .PARAMETER Code
    Multi-line or piped lines of code to process.
    .PARAMETER Name
    Name of fuction to process. If no funciton is given first the entire script will be processed for general parameters. If none are found every function in the script will be processed.
    .PARAMETER ScriptParameters
    Parse for script parameters only.
    .PARAMETER IncludeEmbedded
    Include functions within other functions.
    .EXAMPLE
    PS > $testfile = 'C:\temp\test.ps1'
    PS > $test = Get-Content $testfile -raw
    PS > $test | Get-FunctionParameter -ScriptParameters

    Takes C:\temp\test.ps1 as input, gathers any script's parameters and prints the output to the screen.

    .NOTES
    This will return every parameter of every parameter set. This means you could get far more parameters than you expect.
    Author: Zachary Loeber
    Site: http://www.the-little-things.net/
    Requires: Powershell 3.0

    Version History
    1.0.0 - Initial release
    1.0.1 - Updated function name to remove plural format
            Added Name parameter and logic for getting script parameters if no function is defined.
            Added ScriptParameters parameter to include parameters for a script (not just ones associated with defined functions)
    #>
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline=$true, HelpMessage='Lines of code to process.')]
        [string[]]$Code,
        [parameter(Position=1, HelpMessage='Name of function to process.')]
        [string]$Name = '*',
        [parameter(Position=2, HelpMessage='Try to parse for top-level/non-function script parameters as well.')]
        [switch]$ScriptParameters,
        [parameter(Position=3, HelpMessage='Include parameters and functions of embedded functions.')]
        [switch]$IncludeEmbedded

    )
    begin {
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Verbose "$($FunctionName): Begin."

        $Codeblock = @()
        $ParseError = $null
        $Tokens = $null

        $functionpredicate = {
            ($args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]) -and
            ($args[0].Name -like $name)
        }
        $parampredicate = { ($args[0] -is [System.Management.Automation.Language.ParameterAst]) }
        $typepredicate = { ($args[0] -is [System.Management.Automation.Language.TypeConstraintAst]) }
        $paramattributes = { ($args[0] -is [System.Management.Automation.Language.NamedAttributeArgumentAst]) }
        $output = @()
    }
    process {
        $Codeblock += $Code
        $CommonParams = Get-CommonParameters
    }
    end {
        $ScriptText = ($Codeblock | Out-String).trim("`r`n")
        Write-Verbose "$($FunctionName): Attempting to parse AST."

        $AST = [System.Management.Automation.Language.Parser]::ParseInput($ScriptText, [ref]$Tokens, [ref]$ParseError)

        if($ParseError) {
            throw "$($FunctionName): Will not work properly with errors in the script, please modify based on the above errors and retry."
        }

        if (-not $ScriptParameters) {
            $functions = $CodeBlock | Get-Function -Name $Name
            if (-not $IncludeEmbedded) {
                Write-Verbose "$($FunctionName): Not including embedded functions."
                $functions = $functions | where {-not $_.IsEmbedded}
            }

            Foreach ($f in $functions) {
                $function = $f.ast
                $Parameters = $function.FindAll($parampredicate, $true)
                foreach ($p in $Parameters) {
                    $ParamType = $p.FindAll($typepredicate, $true)
                    Write-Verbose "$($FunctionName): Processing Parameter of type [$($ParamType.typeName.FullName)] - $($p.Name.VariablePath.ToString())"
                    $OutProps = @{
                        'FunctionName' = $function.Name.ToString()
                        'ParameterName' = $p.Name.VariablePath.ToString()
                        'ParameterType' = $ParamType[0].typeName.FullName
                    }
                    # This will add in any other parameter attributes if they are specified (default attributes are thus not included and output may not be normalized)
                    $p.FindAll($paramattributes, $true) | Foreach {
                        $OutProps.($_.ArgumentName) = $_.Argument.Value
                    }
                    $Output += New-Object -TypeName PSObject -Property $OutProps
                }
            }
        }
        else {
            Write-Verbose "$($FunctionName): Processing Script parameters"
            if ($ast.ParamBlock -ne $null) {
                $scriptparams = $ast.ParamBlock
                $Parameters = $scriptparams.FindAll($parampredicate, $true)
                foreach ($p in $Parameters) {
                    $ParamType = $p.FindAll($typepredicate, $true)
                    Write-Verbose "$($FunctionName): Processing Parameter of type [$($ParamType.typeName.FullName)] - $($p.Name.VariablePath.ToString())"
                    $OutProps = @{
                        'FunctionName' = 'Script'
                        'ParameterName' = $p.Name.VariablePath.ToString()
                        'ParameterType' = $ParamType[0].typeName.FullName
                    }
                    # This will add in any other parameter attributes if they are specified (default attributes are thus not included and output may not be normalized)
                    $p.FindAll($paramattributes, $true) | Foreach {
                        $OutProps.($_.ArgumentName) = $_.Argument.Value
                    }
                    $Output += New-Object -TypeName PSObject -Property $OutProps
                }
            }
            else {
                Write-Verbose "$($FunctionName): There were no script parameters found"
            }
        }

        $Output
        Write-Verbose "$($FunctionName): End."
    }
}

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

Function Insert-MissingCBH {
    <#
    .SYNOPSIS
        Create comment based help for a function.
    .DESCRIPTION
        Create comment based help for a function.
    .PARAMETER Code
        Multi-line or piped lines of code to process.
    .EXAMPLE
       PS > $test = Get-Content 'C:\temp\test.ps1' -raw
       PS > $test | Insert-MissingCBH | clip

       Takes C:\temp\test.ps1 as input, creates basic comment based help and puts the result in the clipboard
       to be pasted elsewhere for review.
    .NOTES
       Author: Zachary Loeber
       Site: http://www.the-little-things.net/
       Requires: Powershell 3.0

       Version History
       1.0.0 - Initial release
       1.0.1 - Updated for ModuleBuild
    #>
    [CmdletBinding()]
    param(
        [parameter(Position=0, ValueFromPipeline=$true, HelpMessage='Lines of code to process.')]
        [string[]]$Code
    )

    begin {
        # CBH pattern that tells us CBH likely already exists
        $CBHPattern = "(?ms)(^\s*\<#.*[\.SYNOPSIS|\.DESCRIPTION|\.PARAMETER|\.EXAMPLE|\.NOTES|\.LINK].*?#>)"
        $Codeblock = @()
    }
    process {
        $Codeblock += $Code
    }
    end {
        $ScriptText = ($Codeblock | Out-String).trim("`r`n")
        # If no sign of CBH exists then try to generate and insert it
        if ($ScriptText -notmatch $CBHPattern) {
            $CBH = @($ScriptText | New-CommentBasedHelp)

            if ($CBH.Count -gt 1) {
                throw 'Too many functions are defined in the input string!'
            }

            if ($CBH.Count -ne 0) {
                try {
                    $currscriptblock = [scriptblock]::Create($ScriptText)
                    . $currscriptblock
                    $currfunct = get-command $CBH.FunctionName
                }
                catch {
                    throw $_
                }

                $UpdatedFunct = 'Function ' + $currfunct.Name + ' {' + "`r`n" + $CBH.CBH + "`r`n" + $currfunct.definition + "`r`n" + '}'

                $UpdatedFunct
            }
            else {
                Write-Warning 'Unable to generate CBH for the script text!'
                $ScriptText
            }
        }
        else {
            Write-Verbose "Comment based help already exists - skipping CBH insertion and returning original script."
            $ScriptText
        }
    }
}

function New-CommentBasedHelp {
    <#
    .SYNOPSIS
        Create comment based help for functions within a given scriptblock.
    .DESCRIPTION
        Create comment based help for functions within a given scriptblock.
    .PARAMETER Code
        Multi-line or piped lines of code to process.
    .PARAMETER ScriptParameters
        Process the script parameters as the source of the comment based help.
    .EXAMPLE
       PS > $testfile = 'C:\temp\test.ps1'
       PS > $test = Get-Content $testfile -raw
       PS > $test | New-CommentBasedHelp | clip

       Takes C:\temp\test.ps1 as input, creates basic comment based help and puts the result in the clipboard
       to be pasted elsewhere for review.
    .EXAMPLE
        PS > $CBH = Get-Content 'C:\EWSModule\Get-EWSContact.ps1' -Raw | New-CommentBasedHelp -Verbose
        PS > ($CBH | Where {$FunctionName -eq 'Get-EWSContact'}).CBH

        Consumes Get-EWSContact.ps1 and generates advanced CBH templates for all functions found within. Print out to the screen the advanced
        CBH for just the Get-EWSContact function.
    .NOTES
       Author: Zachary Loeber
       Site: http://www.the-little-things.net/
       Requires: Powershell 3.0

       Version History
       1.0.0 - Initial release
       1.0.1 - Updated for ModuleBuild
    #>
    [CmdletBinding()]
    param(
        [parameter(Position=0, ValueFromPipeline=$true, HelpMessage='Lines of code to process.')]
        [string[]]$Code,
        [parameter(Position=1, HelpMessage='Process the script parameters as the source of the comment based help.')]
        [switch]$ScriptParameters
    )
    begin {
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Verbose "$($FunctionName): Begin."

        $CBH_PARAM = @'
    .PARAMETER %%PARAM%%
    %%PARAMHELP%%
'@

        $Codeblock = @()

        $CBHTemplate = @'
    <#
    .SYNOPSIS
    TBD

    .DESCRIPTION
    TBD

%%PARAMETER%%    .EXAMPLE
    TBD
    #>
'@
    }
    process {
        $Codeblock += $Code
    }
    end {
        $ScriptText = ($Codeblock | Out-String).trim("`r`n")
        Write-Verbose "$($FunctionName): Attempting to parse parameters."
        $FuncParams = @{}
        if ($ScriptParameters) {
            $FuncParams.ScriptParameters = $true
        }
        $AllParams = Get-FunctionParameter @FuncParams -Code $Codeblock | Sort-Object -Property FunctionName
        $AllFunctions = @($AllParams.FunctionName | Select -unique)

        foreach ($f in $AllFunctions) {
            $OutCBH = @{}
            $OutCBH.FunctionName = $f
            [string]$OutParams = ''
            $fparams = @($AllParams | Where {$_.FunctionName -eq $f} | Sort-Object -Property Position)
            if ($fparams.count -gt 0) {
                $fparams | foreach {
                    $ParamHelpMessage = if ([string]::IsNullOrEmpty($_.HelpMessage)) { $_.ParameterName + " explanation`n`r`n`r"} else {$_.HelpMessage + "`n`r`n`r"}

                    $OutParams += $CBH_PARAM -replace '%%PARAM%%',$_.ParameterName -replace '%%PARAMHELP%%',$ParamHelpMessage
                }
            }
            else {

            }

            $OutCBH.'CBH' = $CBHTemplate -replace '%%PARAMETER%%',$OutParams

            New-Object PSObject -Property $OutCBH
        }

        Write-Verbose "$($FunctionName): End."
    }
}

function New-DynamicParameter {
    <#
    .SYNOPSIS
    Helper function to simplify creating dynamic parameters

    .DESCRIPTION
    Helper function to simplify creating dynamic parameters.

    Example use cases:
        Include parameters only if your environment dictates it
        Include parameters depending on the value of a user-specified parameter
        Provide tab completion and intellisense for parameters, depending on the environment

    Please keep in mind that all dynamic parameters you create, will not have corresponding variables created.
        Use New-DynamicParameter with 'CreateVariables' switch in your main code block,
        ('Process' for advanced functions) to create those variables.
        Alternatively, manually reference $PSBoundParameters for the dynamic parameter value.

    This function has two operating modes:

    1. All dynamic parameters created in one pass using pipeline input to the function. This mode allows to create dynamic parameters en masse,
    with one function call. There is no need to create and maintain custom RuntimeDefinedParameterDictionary.

    2. Dynamic parameters are created by separate function calls and added to the RuntimeDefinedParameterDictionary you created beforehand.
    Then you output this RuntimeDefinedParameterDictionary to the pipeline. This allows more fine-grained control of the dynamic parameters,
    with custom conditions and so on.

    .NOTES
    Credits to jrich523 and ramblingcookiemonster for their initial code and inspiration:
        https://github.com/RamblingCookieMonster/PowerShell/blob/master/New-DynamicParam.ps1
        http://ramblingcookiemonster.wordpress.com/2014/11/27/quick-hits-credentials-and-dynamic-parameters/
        http://jrich523.wordpress.com/2013/05/30/powershell-simple-way-to-add-dynamic-parameters-to-advanced-function/

    Credit to BM for alias and type parameters and their handling

    .PARAMETER Name
    Name of the dynamic parameter

    .PARAMETER Type
    Type for the dynamic parameter.  Default is string

    .PARAMETER Alias
    If specified, one or more aliases to assign to the dynamic parameter

    .PARAMETER Mandatory
    If specified, set the Mandatory attribute for this dynamic parameter

    .PARAMETER Position
    If specified, set the Position attribute for this dynamic parameter

    .PARAMETER HelpMessage
    If specified, set the HelpMessage for this dynamic parameter

    .PARAMETER DontShow
    If specified, set the DontShow for this dynamic parameter.
    This is the new PowerShell 4.0 attribute that hides parameter from tab-completion.
    http://www.powershellmagazine.com/2013/07/29/pstip-hiding-parameters-from-tab-completion/

    .PARAMETER ValueFromPipeline
    If specified, set the ValueFromPipeline attribute for this dynamic parameter

    .PARAMETER ValueFromPipelineByPropertyName
    If specified, set the ValueFromPipelineByPropertyName attribute for this dynamic parameter

    .PARAMETER ValueFromRemainingArguments
    If specified, set the ValueFromRemainingArguments attribute for this dynamic parameter

    .PARAMETER ParameterSetName
    If specified, set the ParameterSet attribute for this dynamic parameter. By default parameter is added to all parameters sets.

    .PARAMETER AllowNull
    If specified, set the AllowNull attribute of this dynamic parameter

    .PARAMETER AllowEmptyString
    If specified, set the AllowEmptyString attribute of this dynamic parameter

    .PARAMETER AllowEmptyCollection
    If specified, set the AllowEmptyCollection attribute of this dynamic parameter

    .PARAMETER ValidateNotNull
    If specified, set the ValidateNotNull attribute of this dynamic parameter

    .PARAMETER ValidateNotNullOrEmpty
    If specified, set the ValidateNotNullOrEmpty attribute of this dynamic parameter

    .PARAMETER ValidateRange
    If specified, set the ValidateRange attribute of this dynamic parameter

    .PARAMETER ValidateLength
    If specified, set the ValidateLength attribute of this dynamic parameter

    .PARAMETER ValidatePattern
    If specified, set the ValidatePattern attribute of this dynamic parameter

    .PARAMETER ValidateScript
    If specified, set the ValidateScript attribute of this dynamic parameter

    .PARAMETER ValidateSet
    If specified, set the ValidateSet attribute of this dynamic parameter

    .PARAMETER Dictionary
    If specified, add resulting RuntimeDefinedParameter to an existing RuntimeDefinedParameterDictionary.
    Appropriate for custom dynamic parameters creation.

    If not specified, create and return a RuntimeDefinedParameterDictionary
    Aappropriate for a simple dynamic parameter creation.

    .EXAMPLE
    Create one dynamic parameter.

    This example illustrates the use of New-DynamicParameter to create a single dynamic parameter.
    The Drive's parameter ValidateSet is populated with all available volumes on the computer for handy tab completion / intellisense.

    Usage: Get-FreeSpace -Drive <tab>

    function Get-FreeSpace
    {
        [CmdletBinding()]
        Param()
        DynamicParam
        {
            # Get drive names for ValidateSet attribute
            $DriveList = ([System.IO.DriveInfo]::GetDrives()).Name

            # Create new dynamic parameter
            New-DynamicParameter -Name Drive -ValidateSet $DriveList -Type ([array]) -Position 0 -Mandatory
        }

        Process
        {
            # Dynamic parameters don't have corresponding variables created,
            # you need to call New-DynamicParameter with CreateVariables switch to fix that.
            New-DynamicParameter -CreateVariables -BoundParameters $PSBoundParameters

            $DriveInfo = [System.IO.DriveInfo]::GetDrives() | Where-Object {$Drive -contains $_.Name}
            $DriveInfo |
                ForEach-Object {
                    if(!$_.TotalFreeSpace)
                    {
                        $FreePct = 0
                    }
                    else
                    {
                        $FreePct = [System.Math]::Round(($_.TotalSize / $_.TotalFreeSpace), 2)
                    }
                    New-Object -TypeName psobject -Property @{
                        Drive = $_.Name
                        DriveType = $_.DriveType
                        'Free(%)' = $FreePct
                    }
                }
        }
    }

    .EXAMPLE
    Create several dynamic parameters not using custom RuntimeDefinedParameterDictionary (requires piping).

    In this example two dynamic parameters are created. Each parameter belongs to the different parameter set, so they are mutually exclusive.

    The Drive's parameter ValidateSet is populated with all available volumes on the computer.
    The DriveType's parameter ValidateSet is populated with all available drive types.

    Usage: Get-FreeSpace -Drive <tab>
        or
    Usage: Get-FreeSpace -DriveType <tab>

    Parameters are defined in the array of hashtables, which is then piped through the New-Object to create PSObject and pass it to the New-DynamicParameter function.
    Because of piping, New-DynamicParameter function is able to create all parameters at once, thus eliminating need for you to create and pass external RuntimeDefinedParameterDictionary to it.

    function Get-FreeSpace
    {
        [CmdletBinding()]
        Param()
        DynamicParam
        {
            # Array of hashtables that hold values for dynamic parameters
            $DynamicParameters = @(
                @{
                    Name = 'Drive'
                    Type = [array]
                    Position = 0
                    Mandatory = $true
                    ValidateSet = ([System.IO.DriveInfo]::GetDrives()).Name
                    ParameterSetName = 'Drive'
                },
                @{
                    Name = 'DriveType'
                    Type = [array]
                    Position = 0
                    Mandatory = $true
                    ValidateSet = [System.Enum]::GetNames('System.IO.DriveType')
                    ParameterSetName = 'DriveType'
                }
            )

            # Convert hashtables to PSObjects and pipe them to the New-DynamicParameter,
            # to create all dynamic paramters in one function call.
            $DynamicParameters | ForEach-Object {New-Object PSObject -Property $_} | New-DynamicParameter
        }
        Process
        {
            # Dynamic parameters don't have corresponding variables created,
            # you need to call New-DynamicParameter with CreateVariables switch to fix that.
            New-DynamicParameter -CreateVariables -BoundParameters $PSBoundParameters

            if($Drive)
            {
                $Filter = {$Drive -contains $_.Name}
            }
            elseif($DriveType)
            {
                $Filter =  {$DriveType -contains  $_.DriveType}
            }

            $DriveInfo = [System.IO.DriveInfo]::GetDrives() | Where-Object $Filter
            $DriveInfo |
                ForEach-Object {
                    if(!$_.TotalFreeSpace)
                    {
                        $FreePct = 0
                    }
                    else
                    {
                        $FreePct = [System.Math]::Round(($_.TotalSize / $_.TotalFreeSpace), 2)
                    }
                    New-Object -TypeName psobject -Property @{
                        Drive = $_.Name
                        DriveType = $_.DriveType
                        'Free(%)' = $FreePct
                    }
                }
        }
    }

    .EXAMPLE
    Create several dynamic parameters, with multiple Parameter Sets, not using custom RuntimeDefinedParameterDictionary (requires piping).

    In this example three dynamic parameters are created. Two of the parameters are belong to the different parameter set, so they are mutually exclusive.
    One of the parameters belongs to both parameter sets.

    The Drive's parameter ValidateSet is populated with all available volumes on the computer.
    The DriveType's parameter ValidateSet is populated with all available drive types.
    The DriveType's parameter ValidateSet is populated with all available drive types.
    The Precision's parameter controls number of digits after decimal separator for Free Space percentage.

    Usage: Get-FreeSpace -Drive <tab> -Precision 2
        or
    Usage: Get-FreeSpace -DriveType <tab> -Precision 2

    Parameters are defined in the array of hashtables, which is then piped through the New-Object to create PSObject and pass it to the New-DynamicParameter function.
    If parameter with the same name already exist in the RuntimeDefinedParameterDictionary, a new Parameter Set is added to it.
    Because of piping, New-DynamicParameter function is able to create all parameters at once, thus eliminating need for you to create and pass external RuntimeDefinedParameterDictionary to it.

    function Get-FreeSpace
    {
        [CmdletBinding()]
        Param()
        DynamicParam
        {
            # Array of hashtables that hold values for dynamic parameters
            $DynamicParameters = @(
                @{
                    Name = 'Drive'
                    Type = [array]
                    Position = 0
                    Mandatory = $true
                    ValidateSet = ([System.IO.DriveInfo]::GetDrives()).Name
                    ParameterSetName = 'Drive'
                },
                @{
                    Name = 'DriveType'
                    Type = [array]
                    Position = 0
                    Mandatory = $true
                    ValidateSet = [System.Enum]::GetNames('System.IO.DriveType')
                    ParameterSetName = 'DriveType'
                },
                @{
                    Name = 'Precision'
                    Type = [int]
                    # This will add a Drive parameter set to the parameter
                    Position = 1
                    ParameterSetName = 'Drive'
                },
                @{
                    Name = 'Precision'
                    # Because the parameter already exits in the RuntimeDefinedParameterDictionary,
                    # this will add a DriveType parameter set to the parameter.
                    Position = 1
                    ParameterSetName = 'DriveType'
                }
            )

            # Convert hashtables to PSObjects and pipe them to the New-DynamicParameter,
            # to create all dynamic paramters in one function call.
            $DynamicParameters | ForEach-Object {New-Object PSObject -Property $_} | New-DynamicParameter
        }
        Process
        {
            # Dynamic parameters don't have corresponding variables created,
            # you need to call New-DynamicParameter with CreateVariables switch to fix that.
            New-DynamicParameter -CreateVariables -BoundParameters $PSBoundParameters

            if($Drive)
            {
                $Filter = {$Drive -contains $_.Name}
            }
            elseif($DriveType)
            {
                $Filter = {$DriveType -contains  $_.DriveType}
            }

            if(!$Precision)
            {
                $Precision = 2
            }

            $DriveInfo = [System.IO.DriveInfo]::GetDrives() | Where-Object $Filter
            $DriveInfo |
                ForEach-Object {
                    if(!$_.TotalFreeSpace)
                    {
                        $FreePct = 0
                    }
                    else
                    {
                        $FreePct = [System.Math]::Round(($_.TotalSize / $_.TotalFreeSpace), $Precision)
                    }
                    New-Object -TypeName psobject -Property @{
                        Drive = $_.Name
                        DriveType = $_.DriveType
                        'Free(%)' = $FreePct
                    }
                }
        }
    }

    .Example
    Create dynamic parameters using custom dictionary.

    In case you need more control, use custom dictionary to precisely choose what dynamic parameters to create and when.
    The example below will create DriveType dynamic parameter only if today is not a Friday:

    function Get-FreeSpace
    {
        [CmdletBinding()]
        Param()
        DynamicParam
        {
            $Drive = @{
                Name = 'Drive'
                Type = [array]
                Position = 0
                Mandatory = $true
                ValidateSet = ([System.IO.DriveInfo]::GetDrives()).Name
                ParameterSetName = 'Drive'
            }

            $DriveType =  @{
                Name = 'DriveType'
                Type = [array]
                Position = 0
                Mandatory = $true
                ValidateSet = [System.Enum]::GetNames('System.IO.DriveType')
                ParameterSetName = 'DriveType'
            }

            # Create dictionary
            $DynamicParameters = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

            # Add new dynamic parameter to dictionary
            New-DynamicParameter @Drive -Dictionary $DynamicParameters

            # Add another dynamic parameter to dictionary, only if today is not a Friday
            if((Get-Date).DayOfWeek -ne [DayOfWeek]::Friday)
            {
                New-DynamicParameter @DriveType -Dictionary $DynamicParameters
            }

            # Return dictionary with dynamic parameters
            $DynamicParameters
        }
        Process
        {
            # Dynamic parameters don't have corresponding variables created,
            # you need to call New-DynamicParameter with CreateVariables switch to fix that.
            New-DynamicParameter -CreateVariables -BoundParameters $PSBoundParameters

            if($Drive)
            {
                $Filter = {$Drive -contains $_.Name}
            }
            elseif($DriveType)
            {
                $Filter =  {$DriveType -contains  $_.DriveType}
            }

            $DriveInfo = [System.IO.DriveInfo]::GetDrives() | Where-Object $Filter
            $DriveInfo |
                ForEach-Object {
                    if(!$_.TotalFreeSpace)
                    {
                        $FreePct = 0
                    }
                    else
                    {
                        $FreePct = [System.Math]::Round(($_.TotalSize / $_.TotalFreeSpace), 2)
                    }
                    New-Object -TypeName psobject -Property @{
                        Drive = $_.Name
                        DriveType = $_.DriveType
                        'Free(%)' = $FreePct
                    }
                }
        }
    }
    #>
    [CmdletBinding(PositionalBinding = $false, DefaultParameterSetName = 'DynamicParameter')]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [System.Type]$Type = [int],

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [string[]]$Alias,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [switch]$Mandatory,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [int]$Position,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [string]$HelpMessage,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [switch]$DontShow,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [switch]$ValueFromPipeline,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [switch]$ValueFromPipelineByPropertyName,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [switch]$ValueFromRemainingArguments,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [string]$ParameterSetName = '__AllParameterSets',

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [switch]$AllowNull,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [switch]$AllowEmptyString,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [switch]$AllowEmptyCollection,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [switch]$ValidateNotNull,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [switch]$ValidateNotNullOrEmpty,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [ValidateCount(2, 2)]
        [int[]]$ValidateCount,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [ValidateCount(2, 2)]
        [int[]]$ValidateRange,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [ValidateCount(2, 2)]
        [int[]]$ValidateLength,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [ValidateNotNullOrEmpty()]
        [string]$ValidatePattern,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [ValidateNotNullOrEmpty()]
        [scriptblock]$ValidateScript,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [ValidateNotNullOrEmpty()]
        [string[]]$ValidateSet,

        [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'DynamicParameter')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if (!($_ -is [System.Management.Automation.RuntimeDefinedParameterDictionary])) {
                    Throw 'Dictionary must be a System.Management.Automation.RuntimeDefinedParameterDictionary object'
                }
                $true
            })]
        $Dictionary = $false,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'CreateVariables')]
        [switch]$CreateVariables,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'CreateVariables')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                # System.Management.Automation.PSBoundParametersDictionary is an internal sealed class,
                # so one can't use PowerShell's '-is' operator to validate type.
                if ($_.GetType().Name -ne 'PSBoundParametersDictionary') {
                    Throw 'BoundParameters must be a System.Management.Automation.PSBoundParametersDictionary object'
                }
                $true
            })]
        $BoundParameters
    )

    Begin {
        Write-Verbose 'Creating new dynamic parameters dictionary'
        $InternalDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary

        Write-Verbose 'Getting common parameters'
        function _temp { [CmdletBinding()] Param() }
        $CommonParameters = (Get-Command _temp).Parameters.Keys
    }

    Process {
        if ($CreateVariables) {
            Write-Verbose 'Creating variables from bound parameters'
            Write-Debug 'Picking out bound parameters that are not in common parameters set'
            $BoundKeys = $BoundParameters.Keys | Where-Object { $CommonParameters -notcontains $_ }

            foreach ($Parameter in $BoundKeys) {
                Write-Debug "Setting existing variable for dynamic parameter '$Parameter' with value '$($BoundParameters.$Parameter)'"
                Set-Variable -Name $Parameter -Value $BoundParameters.$Parameter -Scope 1 -Force
            }
        }
        else {
            Write-Verbose 'Looking for cached bound parameters'
            Write-Debug 'More info: https://beatcracker.wordpress.com/2014/12/18/psboundparameters-pipeline-and-the-valuefrompipelinebypropertyname-parameter-attribute'
            $StaleKeys = @()
            $StaleKeys = $PSBoundParameters.GetEnumerator() |
                ForEach-Object {
                if ($_.Value.PSobject.Methods.Name -match '^Equals$') {
                    # If object has Equals, compare bound key and variable using it
                    if (!$_.Value.Equals((Get-Variable -Name $_.Key -ValueOnly -Scope 0))) {
                        $_.Key
                    }
                }
                else {
                    # If object doesn't has Equals (e.g. $null), fallback to the PowerShell's -ne operator
                    if ($_.Value -ne (Get-Variable -Name $_.Key -ValueOnly -Scope 0)) {
                        $_.Key
                    }
                }
            }
            if ($StaleKeys) {
                [string[]]"Found $($StaleKeys.Count) cached bound parameters:" + $StaleKeys | Write-Debug
                Write-Verbose 'Removing cached bound parameters'
                $StaleKeys | ForEach-Object {[void]$PSBoundParameters.Remove($_)}
            }

            # Since we rely solely on $PSBoundParameters, we don't have access to default values for unbound parameters
            Write-Verbose 'Looking for unbound parameters with default values'

            Write-Debug 'Getting unbound parameters list'
            $UnboundParameters = (Get-Command -Name ($PSCmdlet.MyInvocation.InvocationName)).Parameters.GetEnumerator()  |
                # Find parameters that are belong to the current parameter set
            Where-Object { $_.Value.ParameterSets.Keys -contains $PsCmdlet.ParameterSetName } |
                Select-Object -ExpandProperty Key |
                # Find unbound parameters in the current parameter set
												Where-Object { $PSBoundParameters.Keys -notcontains $_ }

            # Even if parameter is not bound, corresponding variable is created with parameter's default value (if specified)
            Write-Debug 'Trying to get variables with default parameter value and create a new bound parameter''s'
            $tmp = $null
            foreach ($Parameter in $UnboundParameters) {
                $DefaultValue = Get-Variable -Name $Parameter -ValueOnly -Scope 0
                if (!$PSBoundParameters.TryGetValue($Parameter, [ref]$tmp) -and $DefaultValue) {
                    $PSBoundParameters.$Parameter = $DefaultValue
                    Write-Debug "Added new parameter '$Parameter' with value '$DefaultValue'"
                }
            }

            if ($Dictionary) {
                Write-Verbose 'Using external dynamic parameter dictionary'
                $DPDictionary = $Dictionary
            }
            else {
                Write-Verbose 'Using internal dynamic parameter dictionary'
                $DPDictionary = $InternalDictionary
            }

            Write-Verbose "Creating new dynamic parameter: $Name"

            # Shortcut for getting local variables
            $GetVar = {Get-Variable -Name $_ -ValueOnly -Scope 0}

            # Strings to match attributes and validation arguments
            $AttributeRegex = '^(Mandatory|Position|ParameterSetName|DontShow|HelpMessage|ValueFromPipeline|ValueFromPipelineByPropertyName|ValueFromRemainingArguments)$'
            $ValidationRegex = '^(AllowNull|AllowEmptyString|AllowEmptyCollection|ValidateCount|ValidateLength|ValidatePattern|ValidateRange|ValidateScript|ValidateSet|ValidateNotNull|ValidateNotNullOrEmpty)$'
            $AliasRegex = '^Alias$'

            Write-Debug 'Creating new parameter''s attirubutes object'
            $ParameterAttribute = New-Object -TypeName System.Management.Automation.ParameterAttribute

            Write-Debug 'Looping through the bound parameters, setting attirubutes...'
            switch -regex ($PSBoundParameters.Keys) {
                $AttributeRegex {
                    Try {
                        $ParameterAttribute.$_ = . $GetVar
                        Write-Debug "Added new parameter attribute: $_"
                    }
                    Catch {
                        $_
                    }
                    continue
                }
            }

            if ($DPDictionary.Keys -contains $Name) {
                Write-Verbose "Dynamic parameter '$Name' already exist, adding another parameter set to it"
                $DPDictionary.$Name.Attributes.Add($ParameterAttribute)
            }
            else {
                Write-Verbose "Dynamic parameter '$Name' doesn't exist, creating"

                Write-Debug 'Creating new attribute collection object'
                $AttributeCollection = New-Object -TypeName Collections.ObjectModel.Collection[System.Attribute]

                Write-Debug 'Looping through bound parameters, adding attributes'
                switch -regex ($PSBoundParameters.Keys) {
                    $ValidationRegex {
                        Try {
                            $ParameterOptions = New-Object -TypeName "System.Management.Automation.${_}Attribute" -ArgumentList (. $GetVar) -ErrorAction Stop
                            $AttributeCollection.Add($ParameterOptions)
                            Write-Debug "Added attribute: $_"
                        }
                        Catch {
                            $_
                        }
                        continue
                    }

                    $AliasRegex {
                        Try {
                            $ParameterAlias = New-Object -TypeName System.Management.Automation.AliasAttribute -ArgumentList (. $GetVar) -ErrorAction Stop
                            $AttributeCollection.Add($ParameterAlias)
                            Write-Debug "Added alias: $_"
                            continue
                        }
                        Catch {
                            $_
                        }
                    }
                }

                Write-Debug 'Adding attributes to the attribute collection'
                $AttributeCollection.Add($ParameterAttribute)

                Write-Debug 'Finishing creation of the new dynamic parameter'
                $Parameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList @($Name, $Type, $AttributeCollection)

                Write-Debug 'Adding dynamic parameter to the dynamic parameter dictionary'
                $DPDictionary.Add($Name, $Parameter)
            }
        }
    }

    End {
        if (!$CreateVariables -and !$Dictionary) {
            Write-Verbose 'Writing dynamic parameter dictionary to the pipeline'
            $DPDictionary
        }
    }
}

function Read-HostContinue {
    param (
        [Parameter(Position=0,HelpMessage='Title for your read prompt.')]
        [String]$PromptTitle = '',
        [Parameter(Position=1,HelpMessage='Question to display at the prompt.')]
        [string]$PromptQuestion = 'Continue?',
        [Parameter(Position=2)]
        [string]$YesDescription = 'Do this.',
        [Parameter(Position=3)]
        [string]$NoDescription = 'Do not do this.',
        [Parameter(Position=4)]
        [switch]$DefaultToNo,
        [Parameter(Position=5)]
        [switch]$Force
    )
    if ($Force) {
        (-not $DefaultToNo)
        return
    }
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", $YesDescription
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", $NoDescription

    if ($DefaultToNo) {
        $ConsolePrompt = [System.Management.Automation.Host.ChoiceDescription[]]($no,$yes)
    }
    else {
        $ConsolePrompt = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    }
    if (($host.ui.PromptForChoice($PromptTitle, $PromptQuestion , $ConsolePrompt, 0)) -eq 0) {
        $true
    }
    else {
        $false
    }
}

## PUBLIC MODULE FUNCTIONS AND DATA ##

function Get-BuildEnvironment {
    <#
    .EXTERNALHELP ModuleBuild-help.xml
    .LINK
        https://github.com/zloeber/ModuleBuild/tree/master/release/0.1.0/docs/Functions/Get-BuildEnvironment.md
    #>

    [CmdletBinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [String]$Path
    )
    begin {
        if ($script:ThisModuleLoaded -eq $true) {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        }
    }
    process {
        # If no path was specified take a few guesses
        if ([string]::IsNullOrEmpty($Path)) {
            $Path = (Get-ChildItem -File -Filter "*.buildenvironment.json" -Path '.\','..\','.\build\' | select -First 1).FullName

            if ([string]::IsNullOrEmpty($Path)) {
                throw 'Unable to locate a *.buildenvironment.json file to parse!'
            }
        }
        if (-not (Test-Path $Path)) {
            throw "Unable to find the file: $Path"
        }

        try {
            Get-Content $Path | ConvertFrom-Json
        }
        catch {
            throw "Unable to load the build file in $Path"
        }
    }
}


function Import-ModulePrivateFunction {
    <#
    .EXTERNALHELP ModuleBuild-help.xml
    .LINK
        https://github.com/zloeber/ModuleBuild/tree/master/release/0.1.0/docs/Functions/Import-ModulePrivateFunction.md
    #>

    [CmdletBinding( SupportsShouldProcess = $True, ConfirmImpact = 'High' )]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [String]$Path,
        [parameter(Position = 1, ValueFromPipeline = $TRUE, Mandatory = $TRUE)]
        [String]$ModulePath,
        [parameter(Position = 2)]
        [String]$Name = '*',
        [parameter(Position = 3)]
        [Switch]$DoNotInsertCBH = $true,
        [parameter(Position = 4)]
        [string[]]$ExcludePaths = @('temp','build','.git','.vscode','docs','release','plaster'),
        [parameter(Position = 5)]
        [string[]]$ExcludeFiles = @('.*\.buildenvironment.ps1','.*\.build.ps1','Build\.ps1','Install\.ps1','PreLoad\.ps1','PostLoad\.ps1','.*\.tests\.ps1','.*\.test\.ps1')
    )
    begin {
        if ($script:ThisModuleLoaded -eq $true) {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        }
        if ($ModulePath -notmatch '.*\.[psm1|psd1]') {
            throw 'Please provide the full path to a psm1 or psd1 file to process'
        }

        $ExFiles = $ExcludeFiles | Convert-ArrayToRegex -DoNotEscape

        try {
            $LoadedModule = Import-Module -Name $ModulePath -Force -PassThru
            $PublicFunctions =  $LoadedModule.ExportedCommands.Keys
            $SourceModuleBasePath = Resolve-Path -Path (Split-path $ModulePath)
            Remove-Module -Name $LoadedModule.Name -Force
            Write-Verbose "Exported Functions for module = $PublicFunctions"
        }
        catch {
            throw "Unable to import $ModulePath"
        }

        Write-Verbose "Source Module Base Path = $SourceModuleBasePath"
        $AllSourcefiles = @(Get-ChildItem -Path $SourceModuleBasePath -Directory -Exclude $ExcludePaths | Get-ChildItem -File -Recurse) | Where {($_.Name -notmatch $ExFiles) -and (@('.ps1','.psm1') -contains $_.extension)}

        $AllSourcefiles += @(Get-ChildItem -Path $SourceModuleBasePath -File | Where {(@('.ps1','.psm1') -contains $_.extension) -and ($_.Name -notmatch $ExFiles)})

        $PSBoundParameters.Confirm = $true

        $PrivateFunctions = @()
    }
    process {
        # If no build file path was specified take a few guesses
        if ([string]::IsNullOrEmpty($Path)) {
            $Path = (Get-ChildItem -File -Filter "*.buildenvironment.json" -Path '.\','..\','.\build\' | select -First 1).FullName

            if ([string]::IsNullOrEmpty($Path)) {
                throw 'Unable to locate a *.buildenvironment.json file to parse!'
            }
        }
        if (-not (Test-Path $Path)) {
            throw "Unable to find the file: $Path"
        }

        try {
            $LoadedBuildEnv = Get-Content $Path | ConvertFrom-Json
            $ProjectPath = Split-Path (Split-Path $Path)
            $PrivateSrcPath = Join-Path $ProjectPath $LoadedBuildEnv.PrivateFunctionSource
            Write-Verbose "Destination Private Function Base Path = $PrivateSrcPath"

        }
        catch {
            throw "Unable to load the build file in $Path"
        }

        # Gather all the nonembedded function definitions that are not defined as public functions
        Foreach ($SourceFile in $AllSourceFiles) {
            Write-Verbose "Processing $($SourceFile.FullName)"
            try {
                Get-Content -Path $SourceFile.FullName | Get-Function | ForEach-Object {
                    if ((-not $_.IsEmbedded) -and ($PublicFunctions -notcontains $_.Name) -and ($_.Name -like $Name)) {
                        Write-Verbose "Adding private function definition for $($_.Name)"
                        $PrivateFunctions += $_ | Select Name,Definition,@{n='SourcePath';e={$SourceFile.FullName}}
                    }
                }
            }
            catch {
                Write-Warning "Unable to process $($SourceFile.FullName), there may be errors in this script."
            }
        }

        # Process our candidate private functions
        Foreach ($PrivFunc in $PrivateFunctions) {
            $DestPath = Join-Path $PrivateSrcPath "$($PrivFunc.Name).ps1"
            # Only attempt to copy over new function files, skip if the name already exists in the destination path
            if (-not (Test-Path $DestPath)) {
                if ($pscmdlet.ShouldProcess("$($PrivFunc.Name) from file $($PrivFunc.SourcePath)", "Import private function $($PrivFunc.Name) to the project $($LoadedBuildEnv.ModuleToBuild)?")) {
                    if ($DoNotInsertCBH) {
                        # Skipping comment based help insertion
                        $PrivFunc.definition | Out-File -FilePath $DestPath -Encoding:utf8 -Confirm:$false
                    }
                    else {
                        # inserting comment based help if it doesn't already exist.
                        $PrivFunc.definition | Insert-MissingCBH | Out-File -FilePath $DestPath -Encoding:utf8 -Confirm:$false
                    }
                }
            }
            else {
                Write-Warning "The following private function already exists: $DestPath"
            }
        }
    }
}


function Import-ModulePublicFunction {
    <#
    .EXTERNALHELP ModuleBuild-help.xml
    .LINK
        https://github.com/zloeber/ModuleBuild/tree/master/release/0.1.0/docs/Functions/Import-ModulePublicFunction.md
    #>

    [CmdletBinding( SupportsShouldProcess = $True, ConfirmImpact = 'High' )]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [String]$Path,
        [parameter(Position = 1, ValueFromPipeline = $TRUE, Mandatory = $TRUE)]
        [String]$ModulePath,
        [parameter(Position = 2)]
        [String]$Name = '*',
        [parameter(Position = 3)]
        [Switch]$DoNotInsertCBH
    )
    begin {
        if ($script:ThisModuleLoaded -eq $true) {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        }
        if ($ModulePath -notmatch '.*\.[psm1|psd1]') {
            throw 'Please provide the full path to a psm1 or psd1 file to process'
        }
        else {
            try {
                $LoadedModule = Import-Module -Name $ModulePath -Force -PassThru
                $LoadedFunctions = Get-Command -Module $LoadedModule.Name -CommandType:Function
            }
            catch {
                throw "Unable to import $ModulePath"
            }
        }
    }
    process {
        # If no path was specified take a few guesses
        if ([string]::IsNullOrEmpty($Path)) {
            $Path = (Get-ChildItem -File -Filter "*.buildenvironment.json" -Path '.\','..\','.\build\' | select -First 1).FullName

            if ([string]::IsNullOrEmpty($Path)) {
                throw 'Unable to locate a *.buildenvironment.json file to parse!'
            }
        }
        if (-not (Test-Path $Path)) {
            throw "Unable to find the file: $Path"
        }

        try {
            $LoadedBuildEnv = Get-Content $Path | ConvertFrom-Json
            $ProjectPath = Split-Path (Split-Path $Path)
            $PublicSrcPath = Join-Path $ProjectPath $LoadedBuildEnv.PublicFunctionSource
        }
        catch {
            throw "Unable to load the build file in $Path"
        }

        Foreach ($LoadedFunction in $LoadedFunctions) {
            if ($LoadedFunction.Name -like $Name) {
                $NewScriptFile = Join-Path $PublicSrcPath "$($LoadedFunction.Name).ps1"
                if (-not (Test-Path $NewScriptFile)) {
                    $NewScript = "function $($LoadedFunction.Name) {"
                    $NewScript += $LoadedFunction.Definition
                    $NewScript += '}'

                    if ($pscmdlet.ShouldProcess("$($LoadedFunction.Name)", "Import public function $($LoadedFunction.Name) to the project $($LoadedBuildEnv.ModuleToBuild)?")) {
                        if ($DoNotInsertCBH) {
                            try {
                                Write-Verbose "Writing public script file to $NewScriptFile"
                                $NewScript | Out-File -FilePath $NewScriptFile -Encoding:utf8 -Confirm:$false
                            }
                            catch {
                                throw "Unable to save file $NewScriptFile"
                            }
                        }
                        else {
                            try {
                                $NewScript | Insert-MissingCBH | Out-File -FilePath $NewScriptFile -Encoding:utf8 -Confirm:$false
                            }
                            catch {
                                throw $_
                            }
                        }
                    }
                }
                else {
                    Write-Warning "Skipping the following file as it already exists: $NewScriptFile"
                }
            }
        }
    }
    end {
        Remove-Module -Name $LoadedModule.Name
    }
}


function Initialize-ModuleBuild {
    <#
    .EXTERNALHELP ModuleBuild-help.xml
    .LINK
        https://github.com/zloeber/ModuleBuild/tree/master/release/0.1.0/docs/Functions/Initialize-ModuleBuild.md
    #>

    [CmdletBinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [String]$Path
    )
    begin {
        if ($script:ThisModuleLoaded -eq $true) {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        }
    }
    process {
        $CustomPlasterModulePath = Join-Path $MyModulePath 'plaster\PlasterModule\Plaster.psd1'
        $PostInitMessage = @'
A few items to consider doing next:

1. Add public functions, one per file, to .\src\public
2. Update your default readme.md file at the root project directory
3. Update the about_ModuleName.help.txt file within .\build\docs\en-US
4. Doing ReadTheDocs integration? Cool, update .\build\docs\ReadTheDocs by creating folders representing sections and putting markdown files within them for the pages within those sections.
5. But remember that the markdown files in .\build\docs\Additional need some love too. These get dropped into your project .\docs directory at build time (overwriting anything there in the process!)
6. Update any bits within your *.psd1 that are appropriate to your module but don't mess with the exported function names as those get handled automatically when you do the build.
7. If you enabled sensitive terminology scanning then review and update your terms defined in your buildenvironment.json file (using get-buildenvironment & set-buildenvironment).
8. Change your project logo at src\other\powershell-project.png
9. Build your project with .\Build.ps1

Run Update-Module ModuleBuild every so often to get more recent releases of this project.

Enjoy!
'@

        $PlasterParams = @{
            TemplatePath = Join-Path $MyModulePath 'plaster\ModuleBuild\'
        }
        if (-not [string]::IsNullOrEmpty($Path)) {
            $PlasterParams.DestinationPath = $Path
        }

        if (get-module Plaster) {
            Write-Output 'Removing already loaded version of Plaster as we need to use our custom version instead..'
            Remove-Module Plaster -Force
            $PlasterWasLoaded = $true
        }

        try {
            Import-Module $CustomPlasterModulePath -Scope:Global -Force
        }
        catch {
            throw 'You need the custom plaster module to build this plaster manifest. We were unable to load it for whatever reason.'
        }

        $PlasterResults = invoke-plaster @PlasterParams -NoLogo -PassThru

        if ($PlasterWasLoaded) {
            Write-Output 'Attempting to reimport the Plaster module that we unloaded earlier..'
            Import-Module Plaster #-ErrorAction:SilentlyContinue
        }

        Write-Output ''
        Write-Output "Your new PowerShell project scaffolding has been created in $($PlasterResults.DestinationPath)"
        Write-Output ''
        Write-Output $PostInitMessage
    }
}



function Set-BuildEnvironment {
    <#
    .EXTERNALHELP ModuleBuild-help.xml
    .LINK
        https://github.com/zloeber/ModuleBuild/tree/master/release/0.1.0/docs/Functions/Set-BuildEnvironment.md
    #>

    [CmdletBinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [String]$Path
    )
    DynamicParam {
        # Create dictionary
        $DynamicParameters = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        if ([String]::isnullorempty($Path)) {
            $BuildPaths = @()
            $BuildPaths += (Get-ChildItem .\*.buildenvironment.json).FullName
            $BuildPaths += (Get-ChildItem .\build\*.buildenvironment.json).FullName
            $BuildPath = $BuildPaths | Select-Object -First 1
        }
        else {
            $BuildPath = $Path
        }

        if ((Test-Path $BuildPath) -and ($BuildPath -like "*.buildenvironment.json")) {
            try {
                $LoadedBuildEnv = Get-Content $BuildPath | ConvertFrom-Json
                $NewParams = (Get-Member -Type 'NoteProperty' -InputObject $LoadedBuildEnv).Name
                $NewParams | ForEach-Object {

                    $NewParamSettings = @{
                        Name = $_
                        Type = $LoadedBuildEnv.$_.gettype().Name.toString()
                        ValueFromPipeline = $TRUE
                        HelpMessage = "Update the setting for $($_)"
                    }

                    # Add new dynamic parameter to dictionary
                    New-DynamicParameter @NewParamSettings -Dictionary $DynamicParameters
                }
            }
            catch {
                #throw "Unable to load the build file in $BuildPath"
            }
        }

        # Return dictionary with dynamic parameters
        $DynamicParameters
    }

    begin {
        if ($script:ThisModuleLoaded -eq $true) {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        }
        if ([String]::isnullorempty($Path)) {
            $BuildPaths = @()
            $BuildPaths += (Get-ChildItem .\*.buildenvironment.json).FullName
            $BuildPaths += (Get-ChildItem .\build\*.buildenvironment.json).FullName
            $BuildPath = $BuildPaths | Select-Object -First 1
        }
        else {
            $BuildPath = $Path
        }

        Write-Verbose "Using build file: $BuildPath"
    }
    process {
        New-DynamicParameter -CreateVariables -BoundParameters $PSBoundParameters

        if ((Test-Path $BuildPath) -and ($BuildPath -like "*.buildenvironment.json")) {
            try {
                $LoadedBuildEnv = Get-BuildEnvironment -Path $BuildPath
                Foreach ($ParamKey in ($PSBoundParameters.Keys | Where-Object {$_ -ne 'Path'})) {
                    $LoadedBuildEnv.$ParamKey = $PSBoundParameters[$ParamKey]
                    Write-Output "Updating $ParamKey to be $($PSBoundParameters[$ParamKey])"
                }

                $LoadedBuildEnv | ConvertTo-Json | Out-File -FilePath $BuildPath -Encoding:utf8 -Force
                Write-Output "Saved configuration file - $BuildPath"
            }
            catch {
                throw "Unable to load the build file in $BuildPath"
            }
        }
        else {
            Write-Error "Unable to find or process a buildenvironment.json file!"
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

$ThisModuleLoaded = $true

#endregion Module Cleanup

# Non-function exported public module members might go here.
#Export-ModuleMember -Variable SomeVariable -Function  *

# This file cannot be completely empty. Even leaving this comment is good enough.



