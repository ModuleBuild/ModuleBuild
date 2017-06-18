function Import-ModulePrivateFunction {
    <#
    .SYNOPSIS
    Retrieves private module function definitions and recreates them in your modulebuild based project.

    .DESCRIPTION
    Retrieves private module function definitions and recreates them in your modulebuild based project. This can be used to either upgrade modulebuild for a project or convert an existing module to start using modulebuild. This function will load and then unload the module to work its magic. 'Private' functions are determined by excluding exported functions and using AST to filter out all function definitions in files within the module folder that are not embedded in other functions. This function will not overwrite any existing private function file of the same name.

    .PARAMETER Path
    Specifies the path to a buildenvironment.json file for an existing modulebuild project.

    .PARAMETER ModulePath
    An existing module path to target. Must be a psd1 file.

    .PARAMETER Name
    Function name to import. If none are specified then all functions will be imported.

    .PARAMETER Force
    Do not prompt for every function import.

    .LINK
    https://github.com/zloeber/ModuleBuild

    .EXAMPLE
    Import-ModulePrivateFunction -ModulePath 'C:\Temp\PSCloudFlare\PSCloudFlare.psd1'

    Finds all the functions that are in the module source but not exported and prompts for each of them to recreate them as individual ps1 files within your ModuleBuild src\private directory.

    .NOTES
    This only applies to modules of the type 'Script'.
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
        [Switch]$Force
    )
    begin {
        if ($ModulePath -notmatch '.*\.psd1') {
            throw 'Please provide the full path to a *.psm1 file to process'
        }
        else {
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
        }
        Write-Verbose "Source Module Base Path = $SourceModuleBasePath"
        $AllSourceFiles = Get-ChildItem -Path $SourceModuleBasePath -File -Recurse -Include '*.ps1','*.psm1'

        $PrivateFunctions = @()
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
            $PrivateSrcPath = Join-Path $ProjectPath $LoadedBuildEnv.PrivateFunctionSource
            Write-Verbose "Destination Private Function Base Path = $PrivateSrcPath"

        }
        catch {
            throw "Unable to load the build file in $Path"
        }

        # Gather all the nonembedded function definitions that are not defined as public functions
        Foreach ($SourceFile in $AllSourceFiles) {
            Write-Verbose "Processing $($SourceFile.FullName)"
            Get-Content -Path $SourceFile.FullName | Get-Function | ForEach-Object {
                if ((-not $_.IsEmbedded) -and ($PublicFunctions -notcontains $_.Name) -and ($_.Name -like $Name)) {
                    Write-Verbose "Adding private function definition for $($_.Name)"
                    $PrivateFunctions += $_ | Select Name,Definition,@{n='SourcePath';e={$SourceFile.FullName}}
                }
            }
        }
        Foreach ($PrivFunc in $PrivateFunctions) {
            $DestPath = Join-Path $PrivateSrcPath "$($PrivFunc.Name).ps1"
            if (-not (Test-Path $DestPath)) {
                if ($Force) {
                    $Continue = $true
                }
                else {
                    $Continue = Read-HostContinue -PromptTitle "Function Name = $($PrivFunc.Name), Source File = $($PrivFunc.SourcePath)" -PromptQuestion "Import this as a private function?"
                }
                if ($Continue) {
                    $PrivFunc.definition | Out-File -FilePath $DestPath -Encoding:utf8
                }
            }
            else {
                Write-Warning "The following private function already exists: $DestPath"
            }
        }
    }
}