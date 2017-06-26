function Initialize-ModuleBuild {
    <#
    .SYNOPSIS
    Set up the framework for a ModuleBuild project.

    .DESCRIPTION
    Set up the framework for a ModuleBuild project.

    .PARAMETER Path
    Specifies the path to create the project.

    .LINK
    https://github.com/zloeber/ModuleBuild

    .EXAMPLE
    TBD
    #>

    [CmdletBinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [String]$Path
    )
    begin {
        if ($script:ThisModuleLoaded -eq $true) {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        }
    }
    process {
        $CustomPlasterModulePath = Join-Path $MyModulePath 'plaster\PlasterModule\Plaster.psd1'
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

Run Update-Module ModuleBuild every so often to get more recent releases of this project.

Enjoy!
'@

        $PlasterParams = @{
            TemplatePath = Join-Path $MyModulePath 'plaster\ModuleBuild\'
        }
        if (-not [string]::IsNullOrEmpty($Path)) {
            $PlasterParams.DestinationPath = $Path
        }

        if (get-module Plaster) {
            Write-Output 'Removing already loaded version of Plaster as we need to use our custom version instead..'
            Remove-Module Plaster -Force
            $PlasterWasLoaded = $true
        }

        try {
            Import-Module $CustomPlasterModulePath -Scope:Global -Force
        }
        catch {
            throw 'You need the custom plaster module to build this plaster manifest. We were unable to load it for whatever reason.'
        }

        $PlasterResults = invoke-plaster @PlasterParams -NoLogo -PassThru

        if ($PlasterWasLoaded) {
            Write-Output 'Attempting to reimport the Plaster module that we unloaded earlier..'
            Import-Module Plaster #-ErrorAction:SilentlyContinue
        }

        Write-Output ''
        Write-Output "Your new PowerShell project scaffolding has been created in $($PlasterResults.DestinationPath)"
        Write-Output ''
        Write-Output $PostInitMessage
    }
}