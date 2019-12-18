<#
    Make the plaster template manifest file for this project.
#>

$ModuleBuildPath = Join-Path $BuildToolPath 'plaster\template\plasterManifest.xml'

Write-Description 'Creating the plaster manifest file for this project...' -Color White -level 3

# First ensure that our custom version of Plaster is loaded
Remove-Module Plaster -ErrorAction:SilentlyContinue
try {
    Import-Module $(Join-Path $BuildToolPath "dependencies\embeded\plaster\1.1.0-c\Plaster.psd1")
}
catch {
    throw 'You need the plaster module to build this plaster manifest.'
}

# Load our parameter and content
. $(Join-Path $BuildToolPath "plaster\manifesttools\PlasterParams.ps1")
. $(Join-Path $BuildToolPath "plaster\manifesttools\PlasterContent.ps1")

# set version
$version = (git describe --tags --always --match "v[0-9]*") -replace 'v',''
if ($null -eq $version) {
    $version = '0.0.1'
}
elseif ($version -match '^([0-9]\.[0-9]\.[0-9]).*$') {
    $version = $Matches[1]
}
else {
    $version = '0.0.1'
}

# set params to pass to New-PlasterManifest
$params = @{
    Path = $ModuleBuildPath
    TemplateName = 'ModuleBuild'
    TemplateVersion = $version
    Author = 'Zachary Loeber'
    Description = 'Create a new PowerShell Module with a ModuleBuild wrapper'
    Tags = 'Module, ModuleManifest, ModuleBuild'
    Title = 'New ModuleBuild Project'
    TemplateType = 'Project'
    Content = $Content | Write-PlasterManifestContent
    Parameters = $Parameters | Write-PlasterParameter
}

# Create the initial manifest
New-PlasterManifest @params

# Test our manifest
try {
    $null = Test-PlasterManifest $ModuleBuildPath -Verbose
    Write-Description "The new plaster manifest for ModuleBuild has been created in $ModuleBuildPath" -Color White -level 3
}
catch {
    Test-PlasterManifest $ModuleBuildPath -verbose
}

# Ensure that our custom version of Plaster is removed
Remove-module Plaster