function Add-PublicFunction {
    <#
    .SYNOPSIS
    Adds a public function to your modulebuild based project based on defined templates.
    .DESCRIPTION
    Adds a public function to your modulebuild based project.
    .PARAMETER Name
    Name of the function to add. Must use a valid PowerShell verb-action format and be singular.
    .PARAMETER Force
    Ignore function name best practices warnings.
    .LINK
    https://github.com/zloeber/ModuleBuild
    .EXAMPLE
    Add-PublicFunction -Name 'New-AwesomeFunction' -TemplateName:PlainPublicFunction
    #>

    [CmdletBinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [string]$Name,
        [switch]$Force
    )
    dynamicparam {
        # Create dictionary
        $DynamicParameters = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $BuildPath = (Get-ChildItem -File -Filter "*.buildenvironment.json" -Path '.\','..\','.\build\' | Select-Object -First 1).FullName

        if ((Test-Path $BuildPath) -and ($BuildPath -like "*.buildenvironment.json")) {
            try {
                $LoadedBuildEnv = Get-Content $BuildPath | ConvertFrom-Json
                $TemplateNames = @((Get-ChildItem -Path $LoadedBuildEnv.FunctionTemplates -Filter '*.tem').BaseName)

                $NewParamSettings = @{
                    Name = 'TemplateName'
                    Type = 'string'
                    ValidateSet = $TemplateNames
                    HelpMessage = "Use this template file for the new function"
                }

                # Add new dynamic parameter to dictionary
                New-DynamicParameter @NewParamSettings -Dictionary $DynamicParameters
            }
            catch {
                throw "Unable to load the build file in $BuildPath"
            }
        }

        # Return dictionary with dynamic parameters
        $DynamicParameters
    }
    begin {
        if ($script:ThisModuleLoaded -eq $true) {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        }
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Verbose "$($FunctionName): Begin."
    }
    process {
        # Pull in the dynamic parameters first
        New-DynamicParameter -CreateVariables -BoundParameters $PSBoundParameters

        # Attempt to get the build environment data and create our template lookup table
        try {
            $BuildEnvInfo = Get-BuildEnvironment
            $BuildEnvPath = Split-Path (Split-Path ((Get-ChildItem -File -Filter "*.buildenvironment.json" -Path '.\','..\','.\build\' -ErrorAction:SilentlyContinue | Select-Object -First 1).FullName))
            $PublicFunctionSrc = Join-Path $BuildEnvPath $BuildEnvInfo.PublicFunctionSource
            $TemplatePath = Join-Path $BuildEnvPath $BuildEnvInfo.FunctionTemplates
            $TemplateLookup = @{}
            Get-ChildItem -Path $TemplatePath -Filter '*.tem' | Foreach {
                $TemplateLookup.($_.BaseName) = $_.FullName
            }
            $BuildEnvVars = (Get-Member -Type 'NoteProperty' -InputObject $LoadedBuildEnv).Name
        }
        catch {
            throw "Unable to find or load a buildenvironment json file!"
        }

        Write-Verbose "Using public function directory: $PublicFunctionSrc"
        Write-Verbose "Using function template path: $TemplatePath"

        $TemplateData = Get-Content -Path $TemplateLookup[$TemplateName]
        $FunctionFullPath = (Join-Path $PublicFunctionSrc $Name) + ".ps1"
        if ((Test-PublicFunctionName $Name -ShowIssues) -or $Force) {
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
                $FunctionFileName = Split-Path $NewFunction -Leaf
                $FunctionName = ($FunctionFileName -split '\.')[0]
                Write-Verbose "Function FileName: $FunctionFileName"
                Write-Verbose "Function Name: $FunctionName"
                Write-Output "Creating new public function called $FunctionName.ps1 from template: $TemplateName"

                # Start by replacing the functionname
                $NewFunctionOutput = $TemplateData -replace '%%FunctionName%%', $FunctionName

                # Next replace any other variables found in our build environment file that exist in the template.
                $BuildEnvVars | Foreach {
                    Write-Verbose "   Replacing %%$($_)%% with $($BuildEnvInfo.$_) if found in template..."
                    $NewFunctionOutput = $NewFunctionOutput -replace "%%$($_)%%", ($BuildEnvInfo.$_ -join ',')
                }

                $NewFunctionOutput | Out-File -FilePath $NewFunction -Force
            }
        }
    }
}