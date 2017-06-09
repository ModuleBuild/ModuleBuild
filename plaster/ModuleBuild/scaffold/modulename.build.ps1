param (
    [parameter(Position = 0)]
    [string]$BuildFile = (Join-Path $BuildRoot 'build\<%=$PLASTER_PARAM_ModuleName%>.buildenvironment.ps1'),
    [parameter(Position = 1)]
    [version]$NewVersion = $null,
    [parameter(Position = 2)]
    [string]$ReleaseNotes,
    [parameter(Position = 3)]
    [switch]$Force
)

if (Test-Path $BuildFile) {
    . $BuildFile
}
else {
    throw "Without a build environment file we are at a loss as to what to do!"
}

# These are required for a full build process and will be automatically installed if they aren't available
$RequiredModules = @('PlatyPS', 'Pester')

# Some optional modules
if ($Script:BuildEnv.OptionAnalyzeCode) {
    $RequiredModules += 'PSScriptAnalyzer'
}

if ($Script:BuildEnv.OptionGenerateReadTheDocs) {
    $RequiredModules += 'Powershell-YAML'
}

# You really shouldn't change this for a powershell module (if you want it to publish to the psgallery correctly)
$CurrentReleaseFolder = $Script:BuildEnv.ModuleToBuild

# Put together our full paths. Generally leave these alone
$ModuleFullPath = Join-Path $BuildRoot "$($Script:BuildEnv.ModuleToBuild).psm1"
$ModuleManifestFullPath = Join-Path $BuildRoot "$($Script:BuildEnv.ModuleToBuild).psd1"
$BuildDocsPath = Join-Path $BuildRoot "$($Script:BuildEnv.BuildToolFolder)\docs\"
$ProjectDocsPath = Join-Path $BuildRoot 'docs'
$ScratchPath = Join-Path $BuildRoot $Script:BuildEnv.ScratchFolder
$ReleasePath = Join-Path $BuildRoot $Script:BuildEnv.BaseReleaseFolder
$CurrentReleasePath = Join-Path $ReleasePath $CurrentReleaseFolder

# Just before releasing the module we stage some changes in this location.
$StageReleasePath = Join-Path $ScratchPath $Script:BuildEnv.BaseReleaseFolder
$ReleaseModule = "$($StageReleasePath)\$($Script:BuildEnv.ModuleToBuild).psm1"

# Additional build scripts and tools are found here (note that any dot sourced functions must be scoped at the script level)
$BuildToolPath = Join-Path $BuildRoot $Script:BuildEnv.BuildToolFolder

# Used later to determine if we are in a configured state or not
$IsConfigured = $False

# Used to update our function CBH to external help reference
$ExternalHelp = @"
<#
    .EXTERNALHELP $($Script:BuildEnv.ModuleToBuild)-help.xml
    .LINK
        {{LINK}}
    #>
"@

if ($Script:BuildEnv.OptionTranscriptEnabled) {
    Write-Build White 'Transcript logging: TRUE'
    $TranscriptLog = Join-Path $BuildToolPath $Script:BuildEnv.OptionTranscriptLogFile
    Write-Build White "TranscriptLog: $($TranscriptLog)"
    Start-Transcript -Path $TranscriptLog -Append -WarningAction:SilentlyContinue
}

#Synopsis: Validate system requirements are met
task ValidateRequirements {
    Write-Build White '      Running Powershell version 5?'
    assert ($PSVersionTable.PSVersion.Major.ToString() -eq '5') 'Powershell 5 is required for this build to function properly (you can comment this assert out if you are able to work around this requirement)'
}

#Synopsis: Load required modules if available. Otherwise try to install, then load it.
task LoadRequiredModules {
    $RequiredModules | Foreach-Object {
        if ((get-module $_ -ListAvailable) -eq $null) {
            Write-Build White "      Installing $($_) Module"
            $null = Install-Module $_ -Scope:CurrentUser
        }
        if (get-module $_ -ListAvailable) {
            Write-Build White "      Importing $($_) Module"
            Import-Module $_ -Force
        }
        else {
            throw 'How did you even get here?'
        }
    }
}

#Synopsis: Load dot sourced functions into this build session
task LoadBuildTools {
    # Dot source any build script functions we need to use
    Get-ChildItem $BuildToolPath/dotSource -Recurse -Filter "*.ps1" -File | ForEach-Object {
        Write-Build White "      Dot sourcing script file: $($_.Name)"
        . $_.FullName
    }
}

# Synopsis: Create new module manifest
task CreateModuleManifest -After CreateModulePSM1 {
    $PSD1OutputFile = "$($StageReleasePath)\$($Script:BuildEnv.ModuleToBuild).psd1"
    $ThisPSD1OutputFile = ".\$($Script:BuildEnv.ScratchFolder)\$($Script:BuildEnv.BaseReleaseFolder)\$($Script:BuildEnv.ModuleToBuild).psd1"
    Write-Build White "      Attempting to update the release module manifest file:  $ThisPSD1OutputFile"
    $null = Copy-Item -Path $ModuleManifestFullPath -Destination $PSD1OutputFile -Force
    Update-ModuleManifest -Path $PSD1OutputFile -FunctionsToExport $Script:FunctionsToExport
}

# Synopsis: Load the module project
task LoadModule {
    Write-Build White '      Attempting to load the project module.'
    try {
        $Script:Module = Import-Module $ModuleFullPath -Force -PassThru
    }
    catch {
        throw "Unable to load the project module: $($ModuleFullPath)"
    }
}

# Synopsis: Import the current module manifest file for processing
task LoadModuleManifest {
    assert (test-path $ModuleManifestFullPath) "Unable to locate the module manifest file: $ModuleManifestFullPath"
    Write-Build White '      Loading the existing module manifest for this module'
    $Script:Manifest = Test-ModuleManifest -Path $ModuleManifestFullPath
}

# Synopsis: Valiates there is no version mismatch.
task Version LoadModuleManifest, {
    Write-Build White '      Manifest version and the release version in the build configuration file are the same?'
    assert ( ($Script:Manifest).Version.ToString() -eq (($Script:BuildEnv.ModuleVersion)) ) "The module manifest version ( $(($Script:Manifest).Version.ToString()) ) and release version ($($Script:BuildEnv.ModuleVersion)) are mismatched. These must be the same before continuing. Consider running the UpdateRelease task to make the module manifest version the same as the release version."
}

#Synopsis: Validate script requirements are met, load required modules, load project manifest and module, and load additional build tools.
task Configure -if {-not $Script:IsConfigured} ValidateRequirements, LoadRequiredModules, LoadModuleManifest, LoadModule, Version, LoadBuildTools, {
    # If we made it this far then we are configured!
    $Script:IsConfigured = $True
    Write-Build White '      Configuring build environment'
}

# Synopsis: Set a new version of the module
task NewVersion -if {$null -ne $NewVersion} LoadBuildTools, LoadModuleManifest, {
    Write-Build White '      Updating module build version'

    $ReleasePath = Join-Path $BuildRoot $Script:BuildEnv.BaseReleaseFolder
    $AllReleases = @((Get-ChildItem $ReleasePath -Directory | Where-Object {$_.Name -match '^([0-9].[0-9].[0-9])$'} | Select-Object).Name | ForEach-Object {[version]$_})

    if (($AllReleases -contains $NewVersion) -and (-not $Force)) {
        Write-Build Red 'The module version already has been released (the folder exists within the releases folder. In order to set your build project to this version you will need to pass the -Force switch to this build script with the -NewVersion parameter'
        throw 'Unable to update build project version!'
    }

    $Script:BuildEnv.ModuleVersion = $NewVersion.ToString()

    Save-BuildData
}

# Synopsis: Update current module manifest with the version defined in the build config file (if they differ)
task UpdateRelease LoadBuildTools, LoadModuleManifest, {
    # If there is a version mismatch then we need to put in some release notes and update the module manifest
    if ($null -eq $ReleaseNotes) {
        do {
            $ReleaseNotes = Read-Host -Prompt 'Enter brief release notes for this new version'
            if ([string]::IsNullOrEmpty($ReleaseNotes)) {
                Write-Build Red "You need to enter some kind of notes for your new release to update the manifest with!"
            }
        } while ([string]::IsNullOrEmpty($NewReleaseNotes))
    }

    Update-ModuleManifest -Path $ModuleManifestFullPath -ModuleVersion $Script:BuildEnv.ModuleVersion -ReleaseNotes $ReleaseNotes
}

# Synopsis: Regenerate scratch staging directory
task Clean {
    Write-Build White "      Clean up our scratch/staging directory at .\$($Script:BuildEnv.ScratchFolder)"
    $null = Remove-Item $ScratchPath -Force -Recurse -ErrorAction 0
    $null = New-Item $ScratchPath -ItemType:Directory
}

# Synopsis: Create base content tree in scratch staging area
task PrepareStage {
    Write-Build White "      Populate the skeleton scratch/staging directory"

    # Create the directories
    $null = New-Item "$($ScratchPath)\src" -ItemType:Directory -Force
    $null = New-Item $StageReleasePath -ItemType:Directory -Force

    Copy-Item -Path "$($BuildRoot)\*.psm1" -Destination $ScratchPath
    Copy-Item -Path "$($BuildRoot)\*.psd1" -Destination $ScratchPath
    Copy-Item -Path "$($BuildRoot)\$($Script:BuildEnv.PublicFunctionSource)" -Recurse -Destination "$($ScratchPath)\$($Script:BuildEnv.PublicFunctionSource)"
    Copy-Item -Path "$($BuildRoot)\$($Script:BuildEnv.PrivateFunctionSource)" -Recurse -Destination "$($ScratchPath)\$($Script:BuildEnv.PrivateFunctionSource)"
    Copy-Item -Path "$($BuildRoot)\$($Script:BuildEnv.OtherModuleSource)" -Recurse -Destination "$($ScratchPath)\$($Script:BuildEnv.OtherModuleSource)"
    Copy-Item -Path (Join-Path $BuildDocsPath 'en-US') -Recurse -Destination $ScratchPath
    $Script:BuildEnv.AdditionalModulePaths | ForEach-Object {
        Copy-Item -Path $_ -Recurse -Destination $ScratchPath -Force
    }
}

# Synopsis: Update public functions to include a template comment based help.
task UpdateCBHtoScratch {
    Write-Build White "      Attempting to insert comment based help into functions (saving to our scratch directory only)."

    $CBHPattern = "(?ms)(^\s*\<#.*\.SYNOPSIS.*?#>)"
    $CBHUpdates = 0

    # Create the directories
    $null = New-Item "$($ScratchPath)\src" -ItemType:Directory -Force
    $null = New-Item "$($ScratchPath)\$($Script:BuildEnv.PublicFunctionSource)" -ItemType:Directory -Force
    Get-ChildItem "$($BuildRoot)\$($Script:BuildEnv.PublicFunctionSource)" -Filter *.ps1 | ForEach-Object {
        $FileName = $_.Name
        $FullFilePath = $_.FullName
        Write-Build White "      Public function - $($FileName)"
        $currscript = Get-Content $FullFilePath -Raw
        $CBH = $currscript | New-CommentBasedHelp
        $currscriptblock = [scriptblock]::Create($currscript)
        . $currscriptblock
        $currfunct = get-command $CBH.FunctionName


        if ($currfunct.definition -notmatch $CBHPattern) {
            $CBHUpdates++
            Write-Build White "      Inserting template CBH and writing to : $($Script:BuildEnv.ScratchFolder)\$($Script:BuildEnv.PublicFunctionSource)\$($FileName)"
            $UpdatedFunct = 'Function ' + $currfunct.Name + ' {' + "`r`n" + $CBH.CBH + "`r`n" + $currfunct.definition + "`r`n" + '}'
            $UpdatedFunct | Out-File "$($ScratchPath)\$($Script:BuildEnv.PublicFunctionSource)\$($FileName)" -Encoding $Script:BuildEnv.Encoding -force
        }
        else {
            Write-Build Yellow "      Comment based help already exists!"
        }

        Remove-Item Function:\$($currfunct.Name)
    }
    Write-Build White ''
    Write-Build  Yellow '****************************************************************************************************'
    Write-Build  Yellow "  Updated Functions: $CBHUpdates"
    if ($CBHUpdates -gt 0) {
        Write-Build White ''
        Write-Build Yellow "  Updated Function Location: $($ScratchPath)\$($Script:BuildEnv.PublicFunctionSource)"
        Write-Build White ''
        Write-Build Yellow "  NOTE: Please inspect these files closely. If they look good merge them back into your project"
    }
    Write-Build  Yellow '****************************************************************************************************'
    $null = Read-Host 'Press Enter to continue...'
}

# Synopsis:  Collect a list of our public methods for later module manifest updates
task GetPublicFunctions {
    Write-Build White '      Parsing for public (exported) function names'
    $Exported = @()
    Get-ChildItem (Join-Path $BuildRoot $Script:BuildEnv.PublicFunctionSource) -Recurse -Filter "*.ps1" -File | Sort-Object Name | ForEach-Object {
        $Exported += ([System.Management.Automation.Language.Parser]::ParseInput((Get-Content -Path $_.FullName -Raw), [ref]$null, [ref]$null)).FindAll( { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false) | ForEach-Object {$_.Name}
    }

    if ($Exported.Count -eq 0) {
        Write-Error 'There are no public functions to export!'
    }
    $Script:FunctionsToExport = $Exported
    Write-Build White "      Number of exported functions found = $($Exported.Count)"
}

# Synopsis: Assemble the module for release
task CreateModulePSM1 {
    if ($Script:BuildEnv.OptionCombineFiles) {
        Write-Build White "      Option to combine PSM1 is enabled, combining source files now..."

        $CombineFiles = ''
        $PreloadFilePath = (Join-Path $ScratchPath "$($Script:BuildEnv.OtherModuleSource)\PreLoad.ps1")
        if (Test-Path $PreloadFilePath) {
            Write-Build White "        Starting with Preload.ps1"
            $CombineFiles += "## Pre-Loaded Module code ##`r`n`r`n"
            Get-childitem $PreloadFilePath | ForEach-Object {
                $CombineFiles += (Get-content $_ -Raw) + "`r`n`r`n"
            }
        }
        Write-Build White "        Adding the private source files:"

        $CombineFiles += "## PRIVATE MODULE FUNCTIONS AND DATA ##`r`n`r`n"

        Get-childitem  (Join-Path $ScratchPath "$($Script:BuildEnv.PrivateFunctionSource)\*.ps1") | ForEach-Object {
            Write-Build White "             $($_.Name)"
            $CombineFiles += (Get-content $_ -Raw) + "`r`n`r`n"
        }

        Write-Build White "        Adding the public source files:"

        $CombineFiles += "## PUBLIC MODULE FUNCTIONS AND DATA ##`r`n`r`n"
        Get-childitem  (Join-Path $ScratchPath "$($Script:BuildEnv.PublicFunctionSource)\*.ps1") | ForEach-Object {
            Write-Build White "             $($_.Name)"
            $CombineFiles += (Get-content $_ -Raw) + "`r`n`r`n"
        }

        Write-Build White "        Finishing with Postload.ps1"
        $CombineFiles += "## Post-Load Module code ##`r`n`r`n"
        $PostLoadPath = (Join-Path $ScratchPath "$($Script:BuildEnv.OtherModuleSource)\PostLoad.ps1")
        if (Test-Path $PostLoadPath) {
            Get-childitem  $PostLoadPath | ForEach-Object {
                $CombineFiles += (Get-content $_ -Raw) + "`r`n`r`n"
            }
        }

        Set-Content -Path $Script:ReleaseModule  -Value $CombineFiles -Encoding $Script:BuildEnv.Encoding
    }
    else {
        Write-Build White "      Option to combine PSM1 is NOT enabled, copying over file structure now..."
        Copy-Item -Path (Join-Path $ScratchPath $Script:BuildEnv.OtherModuleSource) -Recurse -Destination $StageReleasePath -Force
        Copy-Item -Path (Join-Path $ScratchPath $Script:BuildEnv.PrivateFunctionSource) -Recurse -Destination $StageReleasePath -Force
        Copy-Item -Path (Join-Path $ScratchPath $Script:BuildEnv.PublicFunctionSource) -Recurse -Destination $StageReleasePath -Force
        Copy-Item -Path (Join-Path $ScratchPath $Script:BuildEnv.ModuleToBuild) -Destination $StageReleasePath -Force
    }


    if (($Script:BuildEnv.AdditionalModulePaths).Count -gt 0) {
        Write-Build White "      Copying over additional module paths now."
        $Script:BuildEnv.AdditionalModulePaths | ForEach-Object {
            Write-Build White "        Copying $_"
            Copy-Item -Path $_ -Recurse -Destination $StageReleasePath -Force
        }
    }
}

# Synopsis: Removes script signatures before creating a combined PSM1 file
task RemoveScriptSignatures -Before CreateModulePSM1 {
    if ($Script:BuildEnv.OptionCombineFiles) {
        Write-Build White '      Remove script signatures from all files'
        Get-ChildItem -Path "$($ScratchPath)\$($Script:BuildEnv.BaseSourceFolder)" -Recurse -File | ForEach-Object {Remove-Signature -FilePath $_.FullName}
    }
}

# Synopsis: Warn about not empty git status if .git exists.
task GitStatus -If (Test-Path .git) {
    $status = exec { git status -s }
    if ($status) {
        Write-Warning "      Git status: $($status -join ', ')"
    }
}

# Synopsis: Validate that sensitive strings are not found in your code
task SanitizeCode -if {$Script:BuildEnv.OptionSanitizeSensitiveTerms} {
    ForEach ($Term in $Script:BuildEnv.OptionSensitiveTerms) {
        Write-Build White "      Checking Files for sensitive string: $Term"
        $TermsFound = Get-ChildItem -Path $ScratchPath -Recurse -File | Where-Object {$_.FullName -notlike "$($StageReleasePath)*"} | Select-String -Pattern $Term
        if ($TermsFound.Count -gt 0) {
            Write-Build White "        Sensitive string found in the following files:"
            $TermsFound | ForEach-Object {
                Write-Build White "          $($_)"
            }
            throw "Sensitive Terms found!"
        }
    }
}

# Synopsis: Replace comment based help with external help in all public functions for this project
task UpdateCBH -Before CreateModulePSM1 {
    $CBHPattern = "(?ms)(\<#.*\.SYNOPSIS.*?#>)"
    Get-ChildItem -Path "$($ScratchPath)\$($Script:BuildEnv.PublicFunctionSource)\*.ps1" -File | ForEach-Object {
        $FormattedOutFile = $_.FullName
        $FileName = $_.Name
        Write-Build White "      Replacing CBH in file: $($FileName)"
        $FunctionName = $FileName -replace '.ps1', ''
        $NewExternalHelp = $ExternalHelp -replace '{{LINK}}', ($Script:BuildEnv.ModuleWebsite + "/tree/master/$($Script:BuildEnv.BaseReleaseFolder)/$($Script:BuildEnv.ModuleVersion)/docs/Functions/$($FunctionName).md")
        $UpdatedFile = (get-content  $FormattedOutFile -raw) -replace $CBHPattern, $NewExternalHelp
        $UpdatedFile | Out-File -FilePath $FormattedOutFile -force -Encoding $Script:BuildEnv.Encoding
    }
}

# Synopsis: Run PSScriptAnalyzer against the assembled module
task AnalyzeScript -After CreateModulePSM1 -if {$Script:BuildEnv.OptionAnalyzeCode} {
    Write-Build White '      Analyzing the project with ScriptAnalyzer.'
    $Analysis = Invoke-ScriptAnalyzer -Path $StageReleasePath
    $AnalysisErrors = @($Analysis | Where-Object {@('Information', 'Warning') -notcontains $_.Severity})

    if ($AnalysisErrors.Count -ne 0) {
        Write-Build White 'The following errors came up in the script analysis:'
        $AnalysisErrors
        Write-Build
        Write-Build White "Note that this was from the script analysis run against $StageReleasePath"
        Prompt-ForBuildBreak -CustomError $AnalysisErrors
    }
}

# Synopsis: Run PSScriptAnalyzer against the public source files.
task AnalyzePublic {
    Write-Build White '      Analyzing the public source files with ScriptAnalyzer.'
    $Analysis = Invoke-ScriptAnalyzer -Path (Join-Path $BuildRoot $Script:BuildEnv.PublicFunctionSource)
    $AnalysisErrors = @($Analysis | Where-Object {@('Information', 'Warning') -notcontains $_.Severity})

    if ($AnalysisErrors.Count -ne 0) {
        Write-Build White 'The following errors came up in the script analysis:'
        $AnalysisErrors
        Write-Build
        Write-Build White "Note that this was from the script analysis run against $($Script:BuildEnv.PublicFunctionSource)"
        #Prompt-ForBuildBreak -CustomError $AnalysisErrors
    }
}

# Synopsis: Build help files for module
task CreateHelp CreateMarkdownHelp, CreateExternalHelp, CreateUpdateableHelpCAB, CreateProjectHelp,AddAdditionalDocFiles, {
    Write-Build White '      Create help files'
}

# Synopsis: Build the markdown help files with PlatyPS
task CreateMarkdownHelp GetPublicFunctions, {
    # First copy over documentation
    Write-Build White '      Creating markdown documentation with PlatyPS'
    Copy-Item -Path "$($ScratchPath)\en-US" -Recurse -Destination $StageReleasePath -Force

    $OnlineModuleLocation = "$($Script:BuildEnv.ModuleWebsite)/$($Script:BuildEnv.BaseReleaseFolder)"
    $FwLink = "$($OnlineModuleLocation)/$($CurrentReleaseFolder)/docs/$($Script:BuildEnv.ModuleToBuild).md"
    $ModulePage = "$($StageReleasePath)\docs\$($Script:BuildEnv.ModuleToBuild).md"

    # Create the function .md files and the generic module page md as well for the distributable module
    $null = New-MarkdownHelp -module $Script:BuildEnv.ModuleToBuild -OutputFolder "$($StageReleasePath)\docs\" -Force -WithModulePage -Locale 'en-US' -FwLink $FwLink -HelpVersion $Script:BuildEnv.ModuleVersion -Encoding ([System.Text.Encoding]::($Script:BuildEnv.Encoding))

    # Replace each missing element we need for a proper generic module page .md file
    $ModulePageFileContent = Get-Content -raw $ModulePage
    $ModulePageFileContent = $ModulePageFileContent -replace '{{Manually Enter Description Here}}', $Script:Manifest.Description
    $Script:FunctionsToExport | Foreach-Object {
        Write-Build White "        Updating definition for the following function: $($_)"
        $TextToReplace = "{{Manually Enter $($_) Description Here}}"
        $ReplacementText = (Get-Help -Detailed $_).Synopsis
        $ModulePageFileContent = $ModulePageFileContent -replace $TextToReplace, $ReplacementText
    }
    $ModulePageFileContent | Out-File $ModulePage -Force -Encoding $Script:BuildEnv.Encoding

    $MissingDocumentation = Select-String -Path "$($StageReleasePath)\docs\*.md" -Pattern "({{.*}})"

    if ($MissingDocumentation.Count -gt 0) {
        Write-Build Yellow ''
        Write-Build Yellow '   The documentation that got generated resulted in missing sections which should be filled out.'
        Write-Build Yellow '   Please review the following sections in your comment based help, fill out missing information and rerun this build:'
        Write-Build Yellow '   (Note: This can happen if the .EXTERNALHELP CBH is defined for a function before running this build.)'
        Write-Build White ''
        Write-Build Yellow "Path of files with issues: $($StageReleasePath)\docs\"
        Write-Build White ''
        $MissingDocumentation | Select-Object FileName, Matches | Format-Table -auto
        Write-Build  Yellow ''
        pause

        throw 'Missing documentation. Please review and rebuild.'
    }
}

# Synopsis: Build the markdown help files with PlatyPS
task CreateExternalHelp {
    Write-Build White '      Creating markdown help files'
    $PlatyPSVerbose = @{}
    if ($Script:BuildEnv.OptionRunPlatyPSVerbose) {
        $PlatyPSVerbose.Verbose = $true
    }
    $null = New-ExternalHelp "$($StageReleasePath)\docs" -OutputPath "$($StageReleasePath)\en-US\" -Force @PlatyPSVerbose
}

# Synopsis: Build the help file CAB with PlatyPS
task CreateUpdateableHelpCAB {
    Write-Build White "      Creating updateable help cab file"
    $PlatyPSVerbose = @{}
    if ($Script:BuildEnv.OptionRunPlatyPSVerbose) {
        $PlatyPSVerbose.Verbose = $true
    }
    $LandingPage = "$($StageReleasePath)\docs\$($Script:BuildEnv.ModuleToBuild).md"
    $null = New-ExternalHelpCab -CabFilesFolder "$($StageReleasePath)\en-US\" -LandingPagePath $LandingPage -OutputFolder "$($StageReleasePath)\en-US\" @PlatyPSVerbose
}

# Synopsis: Build help files for module and ignore missing section errors
task TestCreateHelp Configure, CreateMarkdownHelp, CreateExternalHelp, CreateUpdateableHelpCAB, {
    Write-Build White '      Create help files'
}

# Synopsis: Create a new version release directory for our release and copy our contents to it
task PushVersionRelease {
    Write-Build White "      Attempting to push a version release of the module"

    $ThisReleasePath = Join-Path $ReleasePath $Script:BuildEnv.ModuleVersion
    $ThisBuildReleasePath = ".\$($Script:BuildEnv.BaseReleaseFolder)\$($Script:BuildEnv.ModuleVersion)"
    $null = Remove-Item $ThisReleasePath -Force -Recurse -ErrorAction 0
    $null = New-Item $ThisReleasePath -ItemType:Directory -Force
    Copy-Item -Path "$($StageReleasePath)\*" -Destination $ThisReleasePath -Recurse
    Out-Zip $StageReleasePath "$ReleasePath\$($Script:BuildEnv.ModuleToBuild)-$Version.zip" -overwrite
}

# Synopsis: Create the current release directory and copy this build to it.
task PushCurrentRelease {
    Write-Build White "      Attempting to push a current release of the module"

    $ThisBuildCurrentReleasePath = ".\$($Script:BuildEnv.BaseReleaseFolder)\$($CurrentReleaseFolder)"
    $MostRecentRelease = (Get-ChildItem $ReleasePath -Directory | Where-Object {$_.Name -like "*.*.*"} | Select-Object Name).name | ForEach-Object {[version]$_} | Sort-Object -Descending | Select-Object -First 1
    $ProcessCurrentRelease = $true
    if ($MostRecentRelease) {
        if ($MostRecentRelease -gt [version]$Script:BuildEnv.ModuleVersion) {
            $ProcessCurrentRelease = $false
        }
    }
    if ($ProcessCurrentRelease) {
        Write-Build White "      Pushing a version release to $($ThisBuildCurrentReleasePath)"
        $null = Remove-Item $CurrentReleasePath -Force -Recurse -ErrorAction 0
        $null = New-Item $CurrentReleasePath -ItemType:Directory -Force
        Copy-Item -Path "$($StageReleasePath)\*" -Destination $CurrentReleasePath -Recurse -force
        Out-Zip $StageReleasePath "$ReleasePath\$($Script:BuildEnv.ModuleToBuild)-current.zip" -overwrite
    }
    else {
        Write-Warning '      Unable to push this version as a current release as it is not the most recent version in the release directory!'
    }
}

# Synopsis: Build the markdown help for the functions using PlatyPS for the core project docs.
task CreateProjectHelp {
    Write-Build White '      Creating markdown documentation with PlatyPS for the core project'
    $OnlineModuleLocation = "$($Script:BuildEnv.ModuleWebsite)/$($Script:BuildEnv.BaseReleaseFolder)"
    $FwLink = "$($OnlineModuleLocation)/docs/Functions/$($Script:BuildEnv.ModuleToBuild).md"

    # Create the function .md files for the core project documentation
    $null = New-MarkdownHelp -module $Script:BuildEnv.ModuleToBuild -OutputFolder "$($BuildRoot)\docs\Functions\" -Force -Locale 'en-US' -FwLink $FwLink -HelpVersion $Script:BuildEnv.ModuleVersion -Encoding ([System.Text.Encoding]::($Script:BuildEnv.Encoding)) #-OnlineVersionUrl "$($Script:BuildEnv.ModuleWebsite)/docs/Functions"
}

# Synopsis: Add additional doc files to the final project document folder
task AddAdditionalDocFiles {
    Write-Build White "      Add additional doc files to the project document folder (.\docs) from .\build\docs\Additional\"
    Copy-Item -Path (Join-Path $BuildDocsPath 'Additional\*.md') -Destination (Join-Path $BuildRoot 'docs') -Force
}

# Synopsis: Build ReadTheDocs yml file
task CreateReadTheDocsYML -After AddAdditionalDocFiles -if {$Script:BuildEnv.OptionGenerateReadTheDocs} Configure, {
    Write-Build White '      Create ReadTheDocs definition file and saving to the root project site.'

    $ReadTheDocsPath = Join-Path $BuildDocsPath 'ReadTheDocs'
    $DocsReleasePath = Join-Path $Script:BuildEnv.BaseReleaseFolder $CurrentReleaseFolder
    $YMLFile = Join-Path $BuildRoot 'mkdocs.yml'
    $Pages = [ordered]@{}

    $RTDFolders = Get-ChildItem -Path $ReadTheDocsPath -Directory | Sort-Object -Property Name

    ForEach ($RTDFolder in $RTDFolders) {
        # First copy over to our project document root
        Copy-Item -Path $RTDFolder.FullName -Destination $ProjectDocsPath -Force -Recurse

        $RTDocs = @(Get-ChildItem -Path $RTDFolder.FullName -Filter '*.md' | Sort-Object Name)
        if ($RTDocs.Count -gt 1) {
            $NewSection = @()
            Foreach ($RTDDoc in $RTDocs) {
                $NewSection += @{$RTDDoc.Basename = "$($RTDFolder.Name)\$($RTDDoc.Name)"}
            }
            $Pages[$RTDFolder.Name] = $NewSection
        }
        else {
            $Pages[$RTDFolder.Name] = "$($RTDFolder.Name)\$($RTDocs.Name)"
        }
    }

    # Store all the functions for its own readthedocs section
    if ($Script:FunctionsToExport.Count -gt 1) {
        $Functions = @()
        $Script:FunctionsToExport | ForEach-Object {
            $Functions += @{$_ = "$DocsReleasePath/docs/$_.md"}
        }
        $Pages.Functions = $Functions
    }
    else {
        $Pages.Functions = $Script:FunctionsToExport
    }

    $RTD = @{
        site_name = "$($Script:BuildEnv.ModuleToBuild) Docs"
        repo_url = $Script:BuildEnv.ModuleWebsite
        site_author = $Script:BuildEnv.ModuleAuthor
        edit_uri = "edit/master/docs/"
        theme = "readthedocs"
        copyright = "$($Script:BuildEnv.ModuleToBuild) is licensed under the <a href='$($Script:BuildEnv.ModuleWebsite)/master/LICENSE.md'> license"
        Pages = $Pages
    }
    $RTD | ConvertTo-Yaml | Out-File -Encoding $Script:BuildEnv.Encoding -FilePath $YMLFile -Force
}

# Synopsis: Push with a version tag.
task GitPushRelease Version, {
    $changes = exec { git status --short }
    assert (-not $changes) "Please, commit changes."

    exec { git push }
    exec { git tag -a "v$($Script:BuildEnv.ModuleVersion)" -m "v$($Script:BuildEnv.ModuleVersion)" }
    exec { git push origin "v$($Script:BuildEnv.ModuleVersion)" }
}

# Synopsis: Push to github
task GithubPush Version, {
    exec { git add . }
    if ($ReleaseNotes -ne $null) {
        exec { git commit -m "$ReleaseNotes"}
    }
    else {
        exec { git commit -m "$($Script:BuildEnv.ModuleVersion)"}
    }
    exec { git push origin master }
    $changes = exec { git status --short }
    assert (-not $changes) "Please, commit changes."
}

# Synopsis: Push the project to PSScriptGallery
task PublishPSGallery LoadBuildTools, InstallModule, {
    Write-Build White '      Publishing recent module release to the PowerShell Gallery'

    if (Get-Module $Script:BuildEnv.ModuleToBuild) {
        # If the module is already loaded then unload it.
        Remove-Module $Script:BuildEnv.ModuleToBuild
    }

    # Try to import the module
    Import-Module -Name $Script:BuildEnv.ModuleToBuild

    Write-Build White "      Uploading project to PSGallery: $($Script:BuildEnv.ModuleToBuild)"
    Upload-ProjectToPSGallery -Name $Script:BuildEnv.ModuleToBuild -NuGetApiKey $Script:BuildEnv.NuGetApiKey -Verbose
}

# Synopsis: Remove session artifacts like loaded modules and variables
task BuildSessionCleanup {
    Write-Build White '      Cleaning up the build session'

    # Clean up loaded modules if they are loaded
    $RequiredModules | Foreach-Object {
        Write-Build White "      Removing $($_) module (if loaded)."
        Remove-Module $_  -Erroraction Ignore
    }
    Write-Build White "      Removing $($Script:BuildEnv.ModuleToBuild) module  (if loaded)."
    Remove-Module $Script:BuildEnv.ModuleToBuild -Erroraction Ignore

    # Dot source any post build cleanup scripts.
    Get-ChildItem $BuildToolPath/cleanup -Recurse -Filter "*.ps1" -File | Foreach {
        Write-Build White "      Dot sourcing cleanup script file: $($_.Name)"
        . $_.FullName
    }
    if ($Script:BuildEnv.OptionTranscriptEnabled) {
        Stop-Transcript -WarningAction:Ignore
    }
}

# Synopsis: Install the current built module to the local machine
task InstallModule Version, {
    Write-Build White "      Attempting to install the current module"
    $CurrentModulePath = Join-Path $Script:BuildEnv.BaseReleaseFolder $Script:BuildEnv.ModuleVersion
    assert (Test-Path $CurrentModulePath) 'The current version module has not been built yet!'

    $MyModulePath = "$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules\"
    $ModuleInstallPath = "$($MyModulePath)$($Script:BuildEnv.ModuleToBuild)"
    if (Test-Path $ModuleInstallPath) {
        Write-Build White "      Removing installed module $($Script:BuildEnv.ModuleToBuild)"
        Remove-Item -Path $ModuleInstallPath -Confirm -Recurse
        assert (-not (Test-Path $ModuleInstallPath)) 'Module already installed and you opted not to remove it. Cancelling install operation!'
    }

    Write-Build White "      Installing current module:"
    Write-Build White "         Source - $($CurrentModulePath)"
    Write-Build White "         Destination - $($ModuleInstallPath)"
    Copy-Item -Path $CurrentModulePath -Destination $ModuleInstallPath -Recurse
}

# Synopsis: Test import the current module
task TestInstalledModule Version, {
    Write-Build White "      Test importing the current module version $($Script:BuildEnv.ModuleVersion)"

    $InstalledModules = @(Get-Module -ListAvailable $Script:BuildEnv.ModuleToBuild)
    assert ($InstalledModules.Count -gt 0) 'Unable to find that the module is installed!'
    if ($InstalledModules.Count -gt 1) {
        Write-Warning 'There are multiple installed modules found for this project (shown below). Be aware that this may skew the test results: '
    }
    Import-Module -Name $Script:BuildEnv.ModuleToBuild -MinimumVersion $Script:BuildEnv.ModuleVersion -Force
}

task InstallAndTestModule InstallModule, TestInstalledModule

# Synopsis: The default build
task . `
    Configure,
Clean,
PrepareStage,
GetPublicFunctions,
SanitizeCode,
CreateHelp,
CreateModulePSM1,
PushVersionRelease,
PushCurrentRelease,
CreateProjectHelp,
BuildSessionCleanup

# Synopsis: Instert Comment Based Help where it doesn't already exist (output to scratch directory)
task InsertMissingCBH `
    Configure,
Clean,
UpdateCBHtoScratch,
BuildSessionCleanup

# Synopsis: Test the code formatting module only
task TestCodeFormatting Configure, Clean, PrepareStage, GetPublicFunctions, FormatCode

# Synopsis: Build help files for module and ignore missing section errors
task TestCreateHelp Configure, CreateMarkdownHelp, CreateExternalHelp, CreateUpdateableHelpCAB