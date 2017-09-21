function Add-PublicFunction {
    <#
    .SYNOPSIS
    Adds a public function to your modulebuild based project.
    .DESCRIPTION
    Adds a public function to your modulebuild based project.
    .PARAMETER Name
    Name of the function to add. Must use a valid PowerShell verb-action format and be singular.
    .PARAMETER Force
    Ignore function name best practices warnings.
    .LINK
    https://github.com/zloeber/ModuleBuild
    .EXAMPLE
    Add-PublicFunction -Name 'New-AwesomeFunction'
    #>

    [CmdletBinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [String]$Name,
        [switch]$Force
    )

    begin {
        if ($script:ThisModuleLoaded -eq $true) {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        }
        try {
            $BuildEnvInfo = Get-BuildEnvironment
            $BuildEnvPath = Split-Path (Split-Path ((Get-ChildItem -File -Filter "*.buildenvironment.json" -Path '.\','..\','.\build\' -ErrorAction:SilentlyContinue | select -First 1).FullName))
            $PublicFunctionSrc = Join-Path $BuildEnvPath $BuildEnvInfo.PublicFunctionSource
        }
        catch {
            throw "Unable to find or load a buildenvironment json file!"
        }

        Write-Verbose "Using public function directory: $PublicFunctionSrc"
    }
    process {
        $FunctionFullPath = (Join-Path $PublicFunctionSrc $Name) + ".ps1"
        if (Test-PublicFunctionName $Name -ShowIssues) {
            Write-Verbose "Adding function to be created: $FunctionFullPath"
            $FunctionsToCreate += $FunctionFullPath
        }
    }
    end {
        foreach ($NewFunction in $FunctionsToCreate) {
            if ((test-path $NewFunction) -and (-not $Force)) {
                Write-Warning "Function file already exists, skipping: $NewFunction"
            }
            else {
                $FunctionPath = Split-Path $Name
                $FunctionFileName = Split-Path $Name -Leaf
                $FunctionName = ($FunctionFileName -split '\.')[0]
                Write-Verbose "Function Path: $FunctionPath"
                Write-Verbose "Function FileName: $FunctionFileName"
                Write-Verbose "Function Name: $FunctionName"
                Write-Output "Creating new public function from template: $FunctionName"
                $Script:PrivateFunctionTemplate -replace '%%FunctionName%%', $FunctionName -Replace '%%ModuleAuthor%%',$BuildEnvInfo.ModuleAuthor -replace '%%ModuleWebsite%%',$BuildEnvInfo.ModuleWebsite | Out-File -FilePath $NewFunction -Force
            }
        }
    }
}