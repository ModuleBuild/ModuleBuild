function Test-PublicFunctionName {
    <#
    .SYNOPSIS
    Tests validity of a function name and path.
    .DESCRIPTION
    Tests validity of a function name and path.
    .PARAMETER Name
    Name of the function to add. Must use a valid PowerShell verb-action format and be singular.
    .PARAMETER ShowIssues
    Displays possible issues with function
    .LINK
    https://github.com/zloeber/ModuleBuild
    .EXAMPLE
    TBD
    #>

    [CmdletBinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [String]$Name,
        [parameter(Position = 1)]
        [switch]$ShowIssues
    )

    $FunctionOk = $TRUE

    try {
        $FunctionPath = Split-Path $Name
        $FunctionFileName = Split-Path $Name -Leaf
        $FunctionName = ($FunctionFileName -split '\.')[0]
        Write-Verbose "Function Path: $FunctionPath"
        Write-Verbose "Function FileName: $FunctionFileName"
        Write-Verbose "Function Name: $FunctionName"
    }
    catch {
        if ($ShowIssues) {
            Write-Warning "Function path does not appear to include a path or filename: $Name"
        }
        $FunctionOk = $FALSE
    }

    if ($FunctionName -match '[^a-zA-Z\-]') {
        if ($ShowIssues) {
            Write-Warning "Function name has special characters: $Name"
        }
        $FunctionOk = $FALSE
    }

    if (-not $FunctionName.contains('-')) {
        if ($ShowIssues) {
            Write-Warning "Function name must be in a verb-noun format: $Name"
        }
        $FunctionOk = $FALSE
    }
    else {
        $Verb,$Noun = $FunctionName -split '-'
        $ValidVerbs = (Get-Verb).verb
        if ($ValidVerbs -notcontains $Verb) {
            if ($ShowIssues) {
                Write-Warning "Function verb is not valid, use 'get-verb' for a list of valid verbs: $Name"
            }
            $FunctionOk = $FALSE
        }

        if (IsPlural $Noun) {
            if ($ShowIssues) {
                Write-Warning "Function noun is plural and should be singular: $Name"
            }
            $FunctionOk = $FALSE
        }
    }

    return $FunctionOk
}