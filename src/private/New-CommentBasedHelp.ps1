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