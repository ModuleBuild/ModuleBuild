# ModuleBuild Configuration
Each project has a ModuleBuild configuration file that will get dot sourced into the build engine. This file will, in turn, pull in settings from a json file in the same directory.

**build\ModuleName.buildenvironment.ps1** - The initial dot sourced configuration script for your project. This file gets pulled into the build session at each invocation. You **MUST** update this file if you want to share any build settings with the community at large.

**build\ModuleName.buildenvironment.json** - This gets automatically updated after a first run of the build and will forever after be the single source of truth moving forward for your build settings (unless you run the prior buildenvironment.ps1 script with the -ForcePersist option or update the 'FirstRun' option to be $true). This file is setup to be ignored in the git config file that the project includes so it should be considered a generally safe place to keep things like your Nuget API key or other local settings. There is little preventing you from adding additional settings here manually. When added they will automatically be available within the set-buildenvironment and get-buildenvironment commands included with this module.

You can add items directly to this file if you like and they will be loaded and are able the be read and set with the modulebuild module. Additionally, if there are new settings in the buildenvironment.ps1 BuildEnv definitions then those settings will automatically be saved to this file when detected (so when the next build runs). This is further described in the next section.

## Configuration Process
Whenever you kick off a process involving any of your build steps the ModuleName.buildenvironment.ps1 file is dot sourced into the session. When this file is invoked a few things happen:
1. The default settings that are populated from initializing the project scaffolding are assigned to the global build environment variable that is aptly called 'BuildEnv'.
2. We then look for ModuleName.buildenvironment.json. If it exists, we load and use any settings within the file over any of the default values previously defined in the buildenvironment.ps1 file.
3. We then optionally update the json config file if any of the following conditions are met:
	- The BuildEnv.FirstRun setting is true
	- Settings were found in the BuildEnv variable that were not found in the json file (this allows us a certain level of forward compatibility)
	- The build script was called with the -ForcePersist flag
	- There was no json configuration file to begin with

What this means is that effectively the base settings defined in modulename.buildenvironment.ps1 don't really matter after the first run. After the first run, any changes will need to happen within the json file directly or using some of the helper functions included in this module.

# Helper Functions
There are a few functions you can use to update or view the configuration (if you are not willing to update the json file manually that is).

## Get-BuildEnvironment
Use this against a .buildenvironment.json file to pull in and display all the settings within as a psobject. If you don't specify a json file then it will attempt to guess the correct one to use based on the current directory.

## Set-BuildEnvironment
Use this against a .buildenvironment.json file to set any of the settings within. Dynamic parameters are used to ensure that this function is effectively forward compatible with any new settings/features/changes to the buildenvironment definitions.  If you don't specify a json file then it will attempt to guess the correct one to use based on the current directory.

## Import-ModulePublicFunction
Use this against an existing module directory to load the module into memory and attempt to extract any defined script functions that have been exported into the public source directory of your ModuleBuild project. No existing file will be overwritten.

## Import-ModulePrivateFunction
Use this against an existing module directory to load the module into memory to determine the exported functions. Then the whole module folder will then be crawled for any non-embedded function definitions that do not exist in the exported function list. Finally, you will be prompted to import each of the found candidate private functions into the modulebuild defined private folder for your project. No files will be overwritten.

## Add-PublicFunction
This function will parse your build environment config file for the location of your function templates directory (default = src\templates) and allow you to use one of them to create a new public function for your module. Some basic validation of the function name will be done including:
- Verb-Noun format
- Noun is singular, not plural
- Function doesn't already exist
- Function consists of only a-z, A-Z, and '-'

Any string int he template function that matches the following format will be replaced by the build environment variable in your build configuration file:

`%%<build variable>%%`

As an example, `%%ModuleName%%` would be replaced by your Module project name.
