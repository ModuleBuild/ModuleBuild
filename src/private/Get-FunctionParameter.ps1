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