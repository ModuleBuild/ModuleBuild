function Import-ModulePublicFunction {
    <#
    .SYNOPSIS
    Retrieves public module function definitions and recreates them in your modulebuild based project.

    .DESCRIPTION
    Retrieves module function definitions and recreates them in your modulebuild based project. This can be used to either upgrade modulebuild for a project or convert an existing module to start using modulebuild. This function will load and then unload the module to work its magic.

    .PARAMETER Path
    Specifies the path to a buildenvironment.json file for an existing modulebuild project.

    .PARAMETER ModulePath
    An existing module path to target. Must be a psm1 or psd1 file.

    .PARAMETER Name
    Function name to import. If none are specified then all functions will be imported.

    .PARAMETER DoNotInsertCBH
    Do not attempt to find and insert comment based help into the function.

    .PARAMETER Force
    Do not prompt for every function import.

    .LINK
    https://github.com/zloeber/ModuleBuild

    .EXAMPLE
    Import-ModulePrivateFunction -ModulePath 'C:\Temp\PSCloudFlare\release\PSCloudFlare\PSCloudFlare.psd1' -force

    Finds any non-exported and unembedded functions and automatically creates them in the current modulebuild project private source directory if they don't already exist.

    .NOTES
    This only applies to modules of the type 'Script' and commands of the type 'Function'.
    #>

    [CmdletBinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [String]$Path,
        [parameter(Position = 1, ValueFromPipeline = $TRUE, Mandatory = $TRUE)]
        [String]$ModulePath,
        [parameter(Position = 2)]
        [String]$Name = '*',
        [parameter(Position = 3)]
        [Switch]$DoNotInsertCBH,
        [parameter(Position = 4)]
        [Switch]$Force
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
                    if ($Force) {
                        $Continue = $true
                    }
                    else {
                        $Continue = Read-HostContinue -PromptTitle "Function Name = $($LoadedFunction.Name)" -PromptQuestion "Import this as a public function?"
                    }
                    if ($Continue) {
                        if ($DoNotInsertCBH) {
                            try {
                                Write-Verbose "Writing public script file to $NewScriptFile"
                                $NewScript | Out-File -FilePath $NewScriptFile -Encoding:utf8
                            }
                            catch {
                                throw "Unable to save file $NewScriptFile"
                            }
                        }
                        else {
                            try {
                                $NewScript | Insert-MissingCBH | Out-File -FilePath $NewScriptFile -Encoding:utf8
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