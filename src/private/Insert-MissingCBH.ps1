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