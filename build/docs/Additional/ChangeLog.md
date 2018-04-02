# ModuleBuild Change Log

Project Site: [https://github.com/zloeber/ModuleBuild](https://github.com/zloeber/ModuleBuild)

## Version 0.2.3
- Added ability to pull in some basic information about an existing module manifest files when running initialize-modulebuild.
- Fixed ReadTheDocs generation issues by updating the template to include build\docs\ReadTheDocs in the initialization process.
- Eliminated any customization requirements within the modulename.build.ps1 script to help pave the way for easier modulebuild upgrades to projects.
- Removed some superfluous code in the base build environment script around the RequiredModules variable.
## Version 0.2.2
- Updated vscode tasks.json to fix depreciated syntax.
- Fixed `-Force` switch processing on Add-PublicFunction to still create the function if the provided name is detected as plural.
- Fixed [cleanup script modulebuild execution issue](https://github.com/zloeber/ModuleBuild/issues/5) by separating out the postbuildtask into its own Invoke-Build code block (I had done this a while ago and never rolled up the changes into the Plaster template).
- Fixed a glaring issue with the PlatyPS output where any Guids were 00000000-0000-0000-0000-000000000000 instead of the actual module manifest Guid [reported via issue #6](https://github.com/zloeber/ModuleBuild/issues/6). This happens because we build the module help from the psm1 load of the module in memory, not the psd1 file as that psd1 manifest gets recreated at build time with the appropriate exported functions and such. Basically a chicken/egg scenario. For now we just manually replace the output markdown files with the correct Guid before moving on to the help file packaging.

## Version 0.2.1
- Merged pull request #3 to resolve initialization issues for new modules in directories with spaces in their path.
- Added additional github integration (via .github folder creation with pull and issue template markdown files)
- Fixed improper spelling of 'license' in license creation templating.

## Version 0.1.10
- Fixed the -InsertCBH build task.
- Fixed the missing documentation platyps output to show the actual found line that indicates missing CBH.

## Version 0.1.9
- Removed plaster option to choose to combine the module source at build time (and simply made that behavior the default that can be changed later via Set-BuildEnvironment -OptionCombineFiles $false)
- Added option to run a code health report (via PSCodeHealth) against your public and private function directories prior to starting the build
- Added 'Module plugin' capability. This adds base functionality to the module project itself. The first included module plugin is the nlogmodule logging functionality.

## Version 0.1.6
- Added New-PublicFunction to module along with a template folder and basic function template to start with. Any src\templates\\\<template_name\>.tem file is able to be used for this new feature and any build environment variable surrounded by double percentage symbols will be automatically replaced (ie. %%ModuleName%%).
- Fixed ReadTheDocs yml creation issue with the licensing link.

## Version 0.1.5
- Fixed awful .gitignore settings included in the default scaffolding
- Fixed documentation links to be self-referencing
- Removed AdditionalModulePaths from initial plaster manifest (can just set this with set-buildenvironment after creation)

## Version 0.1.4
- Fixed invalid mkdocs.yml license link reference
- Fixed invalid reference to acknowledgements folder in plaster manifest (thanks Roberto Desideri!)

## Version 0.1.3
- Fixes to mkdocs.yml formatting
- Fixed temp build directory exclusion in .gitignore file

## Version 0.1.2
- Updated vs code task names
- Fixed an issue with a null build environment variable causing dynamic parameters in set-buildenvironment to fail
- Several small scaffolding clean ups.

## Version 0.1.1
- Removed prompts for the nuget api key when running initialize-modulebuild.
- Initialize-ModuleBuild now automatically runs the build environment powershell script for the first time to create the modulebuild json settings file.
- More documentation.
- Fixed some minor scaffolding creation issues.
- Added a 'ForceInstallModule' setting to eliminate build prompt when running the install and test module build tasks when the module is already installed.
- Fixed VS Code tasks.
- Added additional VS Code tasks when pressing ctrl+shift+B.
- Added two new public functions for importing public/private functions from existing modules to a modulebuild project.
- Added setting 'OptionUpdateVersionAfterPublishing' to ensure that this gets done after publishing to the gallery.
- Fixed initial sensitive term settings generation to work on non-domain joined machines.

## Version 0.0.6
- Changed all template files from .ps1 or psm1 to .template and changed the plaster manifest accordingly
- Change all .<filename> files to remove the period so uploads to the gallery will work properly
- Combined the UpdateRelease and NewVersion tasks and made both promptable
- Fixed git version tag issue with the build script for the plaster manifest file.
- Removed options to prompt for different folder names (like public/private/other/temp) and updated all template files and plaster manifest file accordinly.

## Version 0.0.5
- fixes to plaster template creation

## Version 0.0.4
- fixes to psgallery upload

## Version 0.0.3
- Eliminated all '-Before' and '-After' in task definitions
- Added 'Write-Description' helper function and converted all write-build lines to use it instead (for a quick indented output that is easier on the eyes)
- Eliminated a large number of global variables in favor of simply redefining them in local tasks when required
- Setup readthedocs.net yml file generation to fail with warning if the file already exists.
- Fixed the version check to automatically fail if the build you are running already exists in the powershell gallery.
- Applied the -force flag to several tasks where it made sense to do so (need to manually build with Invoke-Build and the -force parameter to use)
- Fixed up Visual Studio Code tasks.json settings
- Added a prebuild folder for processing dependant/separate scripts prior to starting your build
- Updated much of the documentation.

## Version 0.0.2
- Structural changes

## Version 0.0.1
- Initial release
