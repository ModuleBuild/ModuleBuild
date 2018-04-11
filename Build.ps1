#Requires -Version 5

<#
    .SYNOPSIS
        Invokes the process to build a PowerShell Module

    .DESCRIPTION
	    This Script belongs to the PowerShell Module 'ModuleBuild' from Zachary Loeber (zloeber), see https://github.com/zloeber/ModuleBuild

	    The Build Tasks are defined in <MyModuleName>.build.ps1
    
    .PARAMETER BuildModule
       	Invokes the default build Task defined by a dot (task . …) in <MyModuleName>.build.ps1
    
    .PARAMETER UploadPSGallery
    	Invokes this command: Invoke-Build -Task PublishPSGallery
	    It pushes the current release to the PS Script Gallery:
	    Gallery: https://www.powershellgallery.com/
	    Man:     https://docs.microsoft.com/en-us/powershell/gallery/readme
    
    .PARAMETER InstallAndTestModule
    	Invokes this command: Invoke-Build -Task InstallAndTestModule
    	Assigned main tasks:
    	- InstallModule: Install the new built module to the local machine
    	- TestInstalledModule: Calls Import-Module for the new built module
    
    .PARAMETER NewVersion
	    Invokes this command: Invoke-Build -Task UpdateVersion -NewVersion $NewVersion -ReleaseNotes $ReleaseNotes
	    Assigned main tasks:
	    - NewVersion: Set the new version to the module
	    - UpdateRelease: Updates the current module manifest with the ReleaseNotes 
                         and the version defined in the build config file (if they differ)
    
    .PARAMETER IncrementVersion
        ValidateSet: Major, Minor, Patch, Build
        This Parameter defines which part of a semantic versioning (see: https://semver.org/)
        should be automatically incremented: 

        Argument      <Major>.<Minor>.<Patch>.<Build>
        Major           ++       0       0      0
        Minor          Keep     ++       0      0
        Patch          Keep    Keep     ++      0
        Build          Keep    Keep    Keep    ++
    
    .PARAMETER ShowVersion
        Invokes this command: Invoke-Build -Task ShowVersion
    
    .PARAMETER ReleaseNotes
    	Invokes this command: Invoke-Build -Task UpdateVersion -NewVersion $NewVersion -ReleaseNotes $ReleaseNotes
    	Assigned main tasks: See Parameter NewVersion

    .PARAMETER InsertCBH
    	Invokes this command: Invoke-Build -Task InsertMissingCBH
    	Assigned main tasks:
    	- UpdateCBHtoScratch: Update public functions to include a template comment based help.
    
    .PARAMETER ForceInstallModule
	    If a 3rd party Module need to be installed, then Install-Module will use -Force

    .EXAMPLE
        PS C:\> .\Build.ps1
        Builds the Module in the current directory

    .NOTES
    	Original Conecpt & Idea: Zachary Loeber (zloeber)
    	ModuleBuild, see https://github.com/zloeber/ModuleBuild
	    A scaffolding framework which can be used to kickstart a generic PowerShell module project.
#>
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseCmdletCorrectly', '')]
[CmdletBinding(DefaultParameterSetName = 'Build')]
param (
    [parameter(Position = 0, ParameterSetName = 'Build')]
    [switch]$BuildModule,
    [parameter(Position = 1, ParameterSetName = 'Build')]
    [switch]$UploadPSGallery,
    [parameter(Position = 2, ParameterSetName = 'Build')]
    [Alias(InstallAndImportModule)]
    [switch]$InstallAndTestModule,
    [parameter(Position = 3, ParameterSetName = 'Build')]
    [version]$NewVersion,
    [parameter(Position = 4, ParameterSetName = 'Build')]
    [ValidateSet('Major', 'Minor', 'Patch', 'Build', IgnoreCase)]
    [string]$IncrementVersion,
    [parameter(ParameterSetName = 'Build')]
    [switch]$ShowVersion,
    [parameter(Position = 5, ParameterSetName = 'Build')]
    [string]$ReleaseNotes,
    [parameter(Position = 0, ParameterSetName = 'CBH')]
    [switch]$InsertCBH,
    [parameter(Position = 6, ParameterSetName = 'Build')]
    [parameter(Position = 1, ParameterSetName = 'CBH')]
    [switch]$ForceInstallModule
)

function PrerequisitesLoaded {
    # Install required modules if missing
    try {
        if ((get-module InvokeBuild -ListAvailable) -eq $null) {
            Write-Output "Attempting to install the InvokeBuild module..."
            $Splat = @{ Force = ($script:ForceInstallModule.IsPresent -and $script:ForceInstallModule) }
            $null = Install-Module InvokeBuild -Scope:CurrentUser @Splat
        }
        if (get-module InvokeBuild -ListAvailable) {
            Write-Output -NoNewLine "Importing InvokeBuild module"
            Import-Module InvokeBuild -Force
            Write-Output '...Loaded!'
            return $true
        }
        else {
            return $false
        }
    }
    catch {
        return $false
    }
}

function CleanUp {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingEmptyCatchBlock', '')]
    Param ()
    try {
        Write-Output ''
        Write-Output 'Attempting to clean up the session (loaded modules and such)...'
        Invoke-Build -Task BuildSessionCleanup
        Remove-Module InvokeBuild
    }
    catch {}
}

if (-not (PrerequisitesLoaded)) {
    throw 'Unable to load InvokeBuild!'
}

switch ($psCmdlet.ParameterSetName) {
    'CBH' {
        if ($InsertCBH) {
            try {
                Invoke-Build -Task InsertMissingCBH
            }
            catch {
                throw
            }
        }

        CleanUp
    }
    'Build' {
        if ($NewVersion -ne $null) {
            try {
                Invoke-Build -Task UpdateVersion -NewVersion $NewVersion -ReleaseNotes $ReleaseNotes
            }
            catch {
                throw $_
            }
        }
        
        If ($NewVersion -ne $null -or
            $IncrementVersion -ne $null) {
            Try {
                Invoke-Build -Task UpdateVersion -NewVersion $NewVersion -ReleaseNotes $ReleaseNotes -IncrementVersion:$IncrementVersion
            } Catch {
                Throw $_
            }
        }
        
        If ($ShowVersion) {
            Invoke-Build -Task ShowVersion
        }
        
        # If no parameters were specified or the build action was manually specified then kick off a standard build
        if (($psboundparameters.count -eq 0) -or ($BuildModule)) {
            try {
                Invoke-Build
            }
            catch {
                Write-Output 'Build Failed with the following error:'
                Write-Output $_
            }
        }

        # Install and test the module?
        if ($InstallAndTestModule) {
            try {
                Invoke-Build -Task InstallAndTestModule
            }
            catch {
                Write-Output 'Install and test of module failed:'
                Write-Output $_
            }
        }

        # Upload to gallery?
        if ($UploadPSGallery) {
            try {
                Invoke-Build -Task PublishPSGallery
            }
            catch {
                throw 'Unable to upload project to the PowerShell Gallery!'
            }
        }

        CleanUp
    }
}