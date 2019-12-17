<#
    Make the plaster template manifest file for this project.
#>

$ModuleBuildPath = '.\ModuleBuild\plasterManifest.xml'

Write-Output 'Creating the plaster manifest file for this project...'

# First ensure that our custom version of Plaster is loaded
Remove-Module Plaster -ErrorAction:SilentlyContinue
try {
    Import-Module '.\PlasterModule\Plaster.psd1'
}
catch {
    throw 'You need the plaster module to build this plaster manifest.'
}

# Load our parameter and content
. .\PlasterParams.ps1
. .\PlasterContent.ps1

$version = (git describe --match "v[0-9]*") -replace 'v',''
if ($null -eq $version) {
    $version = '0.0.1'
}
elseif ($version -match '^([0-9]\.[0-9]\.[0-9]).*$') {
    $version = $Matches[1]
}
else {
    $version = '0.0.1'
}


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

try {
    $null = Test-PlasterManifest .\ModuleBuild\plasterManifest.xml -Verbose
    Write-Output 'The new plaster manifest for ModuleBuild has been created in .\ModuleBuild\plasterManifest.xml'
}
catch {
    Test-PlasterManifest .\ModuleBuild\plasterManifest.xml -verbose
}

Remove-module Plaster