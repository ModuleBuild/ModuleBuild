# ModuleBuild Change Log

Project Site: [https://github.com/zloeber/ModuleBuild](https://github.com/zloeber/ModuleBuild)

## Version 0.0.1
- Initial release

## Version 0.0.2
- Structural changes

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

## Version 0.0.4
- fixes to psgallery upload

## Version 0.0.5
- fixes to plaster template creation

## Version 0.0.6
- Changed all template files from .ps1 or psm1 to .template and changed the plaster manifest accordingly
- Change all .<filename> files to remove the period so uploads to the gallery will work properly
- Combined the UpdateRelease and NewVersion tasks and made both promptable
- Fixed git version tag issue with the build script for the plaster manifest file.
- Removed options to prompt for different folder names (like public/private/other/temp) and updated all template files and plaster manifest file accordinly.

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

## Version 0.1.2
- Updated vs code task names
- Fixed an issue with a null build environment variable causing dynamic parameters in set-buildenvironment to fail
- Several small scaffolding clean ups.

## Version 0.1.3
- Fixes to mkdocs.yml formatting
- Fixed temp build directory exclusion in .gitignore file

## Version 0.1.4
- Fixed invalid mkdocs.yml license link reference
- Fixed invalid reference to acknowledgements folder in plaster manifest (thanks Roberto Desideri!)

## Version 0.1.5
- Fixed awful .gitignore settings included in the default scaffolding
- Fixed documentation links to be self-referencing
- Removed AdditionalModulePaths from initial plaster manifest (can just set this with set-buildenvironment after creation)

## Version 0.1.6
- Added New-PublicFunction to module along with a template folder and basic function template to start with. Any src\templates\*.tem file is able to be used for this new feature and any build environment variable surrounded by double percentage symbols will be automatically replaced (ie. %%ModuleName%%).
- Fixed ReadTheDocs yml creation issue with the licensing link.
