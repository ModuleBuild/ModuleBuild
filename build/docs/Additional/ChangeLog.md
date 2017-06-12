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