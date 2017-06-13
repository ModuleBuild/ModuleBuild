# ModuleBuild

A scaffolding framework which can be used to kickstart a generic PowerShell module project.

## Description

A scaffolding framework which can be used to kickstart a generic PowerShell module project and much more. This project helps make everything about starting, documenting, building, and eventually releasing your module to the PSGallary a breeze.

## Introduction

A scaffolding framework which can be used to kickstart a generic PowerShell module project with an Invoke-Build backend for regular deployments and other automated tasks.

## Requirements

- PowerShell 5.0

- All other module requirements will be automatically installed at build time if they are not available.

## Installation

Powershell Gallery (PS 5.0, Preferred method)
`install-module ModuleBuild -Scope:CurrentUser`

Manual Installation
`iex (New-Object Net.WebClient).DownloadString("https://github.com/zloeber/ModuleBuild/raw/master/Install.ps1")`

Or clone this repository to your local machine, extract, go to the .\releases\ModuleBuild directory
and import the module to your session to test, but not install this module.

## Features

This build framework for PowerShell modules comes with several appealing baked in features which include;
- Fully portable project directory structure and build process. So portable that you can copy it to another PowerShell 5.0 capable system and it should run the same.
- Automatically combine your public and private functions into one clean psm1 file at build time.
- Automatically update your psd1 file with public functions at build time.
- Automatically scan your module release with PSScriptAnalyzer
- Automatically upload your script to the PowerShell Gallery (with appropriate API key)
- Automatically create project documentation folder structure and yml definition file for ReadTheDocs.org integration
- Visual Studio Code integration (tasks)
- Easy to manage build configuration with forward compatible design and easy to use commands
- Includes ability to scan for sensitive terms (like your company domain name or other items that you may not want published)

## Documentation

Visit the [ReadTheDocs.org documentation](http://modulebuild.readthedocs.io/en/latest/) that this module created a manifest for automatically.

## Versions

### Version 0.0.1
- Initial release

### Version 0.0.2
- Structural changes

### Version 0.0.3
- Eliminated all '-Before' and '-After' in task definitions
- Added 'Write-Description' helper function and converted all write-build lines to use it instead (for a quick indented output that is easier on the eyes)
- Eliminated a large number of global variables in favor of simply redefining them in local tasks when required
- Setup readthedocs.net yml file generation to fail with warning if the file already exists.
- Fixed the version check to automatically fail if the build you are running already exists in the powershell gallery.
- Applied the -force flag to several tasks where it made sense to do so (need to manually build with Invoke-Build and the -force parameter to use)
- Fixed up Visual Studio Code tasks.json settings
- Added a prebuild folder for processing dependant/separate scripts prior to starting your build
- Updated much of the documentation.

## Contribute

Please feel free to contribute by opening new issues or providing pull requests.
For the best development experience, open this project as a folder in Visual
Studio Code and ensure that the PowerShell extension is installed.

* [Visual Studio Code]
* [PowerShell Extension]

More contributing information can be found [here](https://github.com/zloeber/ModuleBuild/blob/master/docs/Contributing.md).

## Other Information

**Author:** Zachary Loeber

**Website:** https://github.com/zloeber/ModuleBuild
