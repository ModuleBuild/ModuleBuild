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