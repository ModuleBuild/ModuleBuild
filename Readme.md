# ModuleBuild

A scaffolding framework which can be used to kickstart a generic PowerShell module project with a bunch of extras.

## Description

A scaffolding framework which can be used to kickstart a generic PowerShell module project with an Invoke-Build backend for regular deployments and other automated tasks. This project helps make everything about starting, documenting, building, and eventually releasing your module to the PSGallary a breeze.

## Requirements

- PowerShell 5.0

- All other module requirements will be automatically installed at build time if they are not available. (This is one of the reasons PowerShell 5 or greater is required)

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
- Functions for importing public and private functions from other projects into a ModuleBuild project
- Add new public functions to your project based on easy to create templates.
## Documentation

Visit the [ReadTheDocs.org documentation](http://modulebuild.readthedocs.io/en/latest/) that this module created a manifest for automatically.

## Contribute

Please feel free to contribute by opening new issues or providing pull requests.
For the best development experience, open this project as a folder in Visual
Studio Code and ensure that the PowerShell extension is installed.

* [Visual Studio Code]
* [PowerShell Extension]

More contributing information can be found [here](https://github.com/zloeber/ModuleBuild/blob/master/docs/Contributing.md).

## Other Information

**Author:** [Zachary Loeber](https://www.the-little-things.net)

**Website:** https://github.com/zloeber/ModuleBuild
