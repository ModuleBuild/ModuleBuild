#Requires -Version 5
#Requires -RunAsAdministrator
[CmdletBinding(DefaultParameterSetName = 'Build')]
param (
    [parameter(Position = 0, ParameterSetName = 'Build')]
    [switch]$BuildModule,
    [parameter(Position = 2, ParameterSetName = 'Build')]
    [switch]$UploadPSGallery,
    [parameter(Position = 3, ParameterSetName = 'Build')]
    [switch]$InstallAndTestModule,
    [parameter(Position = 4, ParameterSetName = 'Build')]
    [version]$NewVersion,
    [parameter(Position = 5, ParameterSetName = 'Build')]
    [string]$ReleaseNotes,
    [parameter(Position = 6, ParameterSetName = 'CBH')]
    [switch]$AddMissingCBH
)

function PrerequisitesLoaded {
    # Install required modules if missing
    try {
        if ((get-module PSDepend -ListAvailable) -eq $null) {
            Write-Host "Attempting to install the PSDepend module..."
            $null = Install-Module PSDepend -Scope:CurrentUser
            Write-Host 'Installed!'
        }
        if (get-module PSDepend -ListAvailable) {
            Write-Host -NoNewLine "Importing PSDepend module"
            Import-Module PSDepend -Force
            Write-Host '...Loaded!'

            Write-Host -NoNewLine 'Installing dependencies...'
            Invoke-PSDepend -Path $(Join-Path $(Get-Location) 'Requirements.psd1') -Test
            Invoke-PSDepend -Path $(Join-Path $(Get-Location) 'Requirements.psd1') -Force
            Invoke-PSDepend -Path $(Join-Path $(Get-Location) 'Requirements.psd1') -Import -Force
            Write-Host 'Installed!'
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
    try {
        Write-Host ''
        Write-Host 'Attempting to clean up the session (loaded modules and such)...'
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
        if ($AddMissingCBH) {
            try {
                Invoke-Build -Task AddMissingCBH
            }
            catch {
                throw
            }
        }
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
        # If no parameters were specified or the build action was manually specified then kick off a standard build
        if (($psboundparameters.count -eq 0) -or ($BuildModule)) {
            try {
                Invoke-Build
            }
            catch {
                Write-Host 'Build Failed with the following error:'
                Write-Host $_
            }
        }

        # Install and test the module?
        if ($InstallAndTestModule) {
            try {
                Invoke-Build -Task InstallAndTestModule
            }
            catch {
                Write-Host 'Install and test of module failed:'
                Write-Host $_
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
    }
}