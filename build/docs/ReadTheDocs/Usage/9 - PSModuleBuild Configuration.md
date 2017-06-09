# ModuleBuild Configuration
Each project has a ModuleBuild configuration file that will get dot sourced into the build engine. This file will, in turn, pull in settings from a json file in the same directory.

**build\ModuleName.buildenvironment.ps1** - The initial dot sourced configuration script for your project. This file gets pulled into the build session at each invocation.

**build\ModuleName.buildenvironment.json** - This gets automatically updated after a first run of the build and will forever after be the single source of truth moving forward for your build settings (unless you run the prior buildenvironment.ps1 script with the -ForcePersist option or update the 'FirstRun' option to be $true).

## Configuration Process
Whenever you kick off a process involving any of your build steps the ModuleName.buildenvironment.ps1 file is dot sourced into the session. When this file runs a few things happen:
1. The default settings that are populated from initializing the project scaffolding are assigned to the global build environment variable that is aptly called 'BuildEnv'.
2. We then look for ModuleName.buildenvironment.json. If it exists we load and overwrite every setting in BuildEnv that is found in the json file.
3. We then optionally update the json config file if any of the following conditions are met:
	- The BuildEnv.FirstRun setting is true
	- Settings were found in the BuildEnv variable that were not found in the json file (this allows us a certain level of forward compatibility)
	- The build script was called with the -ForcePersist flag
	- There was no json configuration file to begin with

What this means is that effectively the base settings defined in modulename.buildenvironment.ps1 don't really matter after the first run. After the first run, any changes will need to happen within the json file directly or using some of the helper functions.

# Helper Functions
There are a few functions you can use to update or view the configuration (if you are  not willing to update the json file manually that is).

## Get-BuildEnvironment
Use this against a .buildenvironment.json file to pull in and display all the settings within as a psobject.

## Set-BuildEnvironment
Use this against a .buildenvironment.json file to set any of the settings within. Dynamic parameters are used to ensure that this function is effectively forward compatible with any new settings/features/changes to the buildenvironment definitions.

