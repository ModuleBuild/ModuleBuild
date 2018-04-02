function Import-ModulePrivateFunction {
    <#
    .SYNOPSIS
    Retrieves private module function definitions and recreates them in your modulebuild based project.

    .DESCRIPTION
    Retrieves private module function definitions and recreates them in your modulebuild based project. This can be used to either upgrade modulebuild for a project or convert an existing module to start using modulebuild. This function will load and then unload the module to work its magic. 'Private' functions are determined by excluding exported functions and using AST to filter out all function definitions in files within the module folder that are not embedded in other functions. This function will not overwrite any existing private function file of the same name.

    .PARAMETER Path
    Specifies the path to a buildenvironment.json file for an existing modulebuild project.

    .PARAMETER ModulePath
    An existing module path to target. Must be a psd1 or psm1 file.

    .PARAMETER Name
    Function name to import. If none are specified then all functions will be imported.

    .PARAMETER DoNotInsertCBH
    Do not attempt to find and insert comment based help into the function. Default for private functions is to skip CBH insertion.

    .PARAMETER ExcludePaths
    Paths within the root of your module source which will be ignored in this import.

    .PARAMETER ExcludeFiles
    Files, in regex pattern format, that will be ignored in this import.

    .LINK
    https://github.com/zloeber/ModuleBuild

    .EXAMPLE
    Import-ModulePrivateFunction -ModulePath 'C:\Temp\PSCloudFlare\PSCloudFlare.psd1'

    Finds all the functions that are in the module source but not exported and prompts for each of them to recreate them as individual ps1 files within your ModuleBuild src\private directory.

    .NOTES
    This only applies to modules of the type 'Script'. Be very careful before importing everything as any wayward functions might get imported and bloat your resulting module needlessly.
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
        $AllSourcefiles = @(Get-ChildItem -Path $SourceModuleBasePath -Directory -Exclude $ExcludePaths | Get-ChildItem -File -Recurse) | Where-Object {($_.Name -notmatch $ExFiles) -and (@('.ps1','.psm1') -contains $_.extension)}

        $AllSourcefiles += @(Get-ChildItem -Path $SourceModuleBasePath -File | Where-Object {(@('.ps1','.psm1') -contains $_.extension) -and ($_.Name -notmatch $ExFiles)})

        $PSBoundParameters.Confirm = $true

        $PrivateFunctions = @()
    }
    process {
        # If no build file path was specified take a few guesses
        if ([string]::IsNullOrEmpty($Path)) {
            $Path = (Get-ChildItem -File -Filter "*.buildenvironment.json" -Path '.\','..\','.\build\' | Select-Object -First 1).FullName

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
                        $PrivateFunctions += $_ | Select-Object Name,Definition,@{n='SourcePath';e={$SourceFile.FullName}}
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