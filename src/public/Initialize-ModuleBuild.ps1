function Initialize-ModuleBuildTesting {
    <#
    .SYNOPSIS
    Set up the framework for a ModuleBuild project.

    .DESCRIPTION
    Set up the framework for a ModuleBuild project. Optionally supply an existing module manifest path to pull in information from it to begin a migration to ModuleBuild.

    .PARAMETER Path
    Specifies the path to create the project.

    .PARAMETER SourceModule
    If specified, will import a source module manifest file for module information.

    .LINK
    https://github.com/zloeber/ModuleBuild

    .EXAMPLE
    PS> Initialize-ModuleBuild -Path C:\Work\NewModule

    Prompt for all the settings required to get a new modulebuild project setup in c:\work\NewModule.

    .EXAMPLE
    PS> Initialize-ModuleBuild -Path C:\Work\NewModule -SourceModule c:\work\myoldmodule\myoldmodule.psd1

    Pulls some information from myoldmodule.psd1 and then prompt for any remaining required information to create a modulebuild based project from it in C:\Work\NewModule

    Prompt for all the settings required to get a new modulebuild project setup in c:\work\NewModule.

    #>

    [CmdletBinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [String]$Path,
        [parameter(Position = 1)]
        [String]$SourceModule
    )
    begin {
        if ($script:ThisModuleLoaded -eq $true) {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        }
        if (-not [string]::IsNullOrEmpty($SourceModule)) {
<#

#>
        }
    }
    process {
        $CustomPlasterModulePath = 'C:\_git\github\ModuleBuild\plaster\PlasterModule\Plaster.psd1'
        $PostInitMessage = @'
A few items to consider doing next:

1. Add public functions, one per file, to .\src\public
2. Update your default readme.md file at the root project directory
3. Update the about_ModuleName.help.txt file within .\build\docs\en-US
4. Doing ReadTheDocs integration? Cool, update .\build\docs\ReadTheDocs by creating folders representing sections and putting markdown files within them for the pages within those sections.
5. But remember that the markdown files in .\build\docs\Additional need some love too. These get dropped into your project .\docs directory at build time (overwriting anything there in the process!)
6. Update any bits within your *.psd1 that are appropriate to your module but don't mess with the exported function names as those get handled automatically when you do the build.
7. If you enabled sensitive terminology scanning then review and update your terms defined in your buildenvironment.json file (using get-buildenvironment & set-buildenvironment).
8. Change your project logo at src\other\powershell-project.png
9. Build your project with .\Build.ps1
10. Enter a PowerShell Gallery (aka Nuget) API key using Set-BuildEnvironment -NugetAPIKey. Without this you will not be able to upload your module to the Gallery

Run Update-Module ModuleBuild every so often to get more recent releases of this project.

Enjoy!
'@

        if (-not [string]::IsNullOrEmpty($SourceModule)) {
            if (-not [string]::IsNullOrEmpty($SourceModule))
            {
                if (-not (test-path $SourceModule) -or ((Get-Item $SourceModule).Extension -notmatch '.psd1')) {
                    throw "$($SourceModule) was not found or is not a psd1 module manifest file!"
                } ElseIf ((test-path $SourceModule) -and (Get-Item $SourceModule).Extension -match '.psd1') {
                    Write-Verbose "$($SourceModule) Matched to .psd1 file"
                }
            }

            $ExistingModuleManifest = Test-ModuleManifest $SourceModule

            $PlasterParams = @{
                TemplatePath = Join-Path $MyModulePath 'plaster\ModuleBuild\';
                ModuleName = $ExistingModuleManifest.Name;
                ModuleDescription = $ExistingModuleManifest.Description;
                ModuleAuthor = $ExistingModuleManifest.Author;
                ModuleCompanyName = $ExistingModuleManifest.CompanyName;
                ModuleWebsite = $ExistingModuleManifest.ProjectURI.ToString();
                ModuleVersion = $ExistingModuleManifest.Version.ToString();
                ModuleTags = $ExistingModuleManifest.Tags -join ',';
            }
        } else {
            $PlasterParams = @{
                TemplatePath = 'C:\_git\github\ModuleBuild\plaster\ModuleBuild\'
            }
        }
        if (-not [string]::IsNullOrEmpty($Path)) {
            $PlasterParams.DestinationPath = $Path
        }

        if (get-module Plaster) {
            Write-Output 'Removing already loaded version of Plaster as we need to use our custom version instead..'
            Remove-Module Plaster -Force
        }

        try {
            Import-Module $CustomPlasterModulePath -Scope:Global -Force
        }
        catch {
            throw 'You need the custom plaster module to build this plaster manifest. We were unable to load it for whatever reason.'
        }

        $PlasterResults = invoke-plaster @PlasterParams -NoLogo -PassThru

        # Get the newly created buildenvironment file and run it the first time to create the first export file.
        $BuildDefinition = Get-ChildItem (Join-Path $PlasterResults.DestinationPath 'build') -Filter '*.buildenvironment.ps1'
        powershell -noprofile -WindowStyle hidden -file $($BuildDefinition.FullName)
        Try {
            if ((Test-Path -Path ($BuildDefinition.FullName -replace '.ps1','.json')) -eq 'True') {
               Write-Verbose 'Found JSON file.'
            } Else {
               Write-Error 'Could not find JSON file' -ErrorAction Stop
           }
        }
        catch {
            throw $_
        }

        Write-Output ''
        Write-Output "Your new PowerShell project scaffolding has been created in $($PlasterResults.DestinationPath)"
        Write-Output ''
        Write-Output $PostInitMessage

        Remove-Module Plaster -Force
    }
}
Initialize-ModuleBuildTesting -Path C:\temp\test