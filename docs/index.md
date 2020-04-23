# ModuleBuild
A scaffolding framework which can be used to kickstart a generic PowerShell module project.

Project Site: [https://github.com/zloeber/ModuleBuild](https://github.com/zloeber/ModuleBuild)

## What is ModuleBuild?
A scaffolding framework which can be used to kickstart a generic PowerShell module project with an Invoke-Build backend for regular deployments and other automated tasks.

## Why use the ModuleBuild Module?
The answer is simple, it takes all the hard work out of authoring and maintaining your PowerShell module. To see why this is simply take a look at some of the features.

### Features
This build framework for PowerShell modules comes with several appealing baked in features which include;

- Fully portable project directory structure and build process. So portable that you can copy it to another PowerShell 5.0 capable system and it should run the same.
- Automatically combine your public and private functions into one clean psm1 file at build time.
- Automatically update your psd1 file with public functions at build time.
- Automatically scan your module release with PSScriptAnalyzer
- Automatically upload your script to the PowerShell Gallery (with appropriate API key)
- Automatically create project documentation folder structure and yml definition file for ReadTheDocs.org integration
- Automatically generate module documentation with PlatyPS
- Visual Studio Code integration (tasks)
- Easy to manage build configuration with forward compatible design and easy to use commands
- Includes ability to scan for sensitive terms (like your company domain name or other items that you may not want published)
- Helper functions to import existing project private and public functions into your ModuleBuild based project

## Installation
ModuleBuild is available on the [PowerShell Gallery](https://www.powershellgallery.com/packages/ModuleBuild/).

To Inspect:
```powershell
Save-Module -Name ModuleBuild -Path <path>
```
To install:
```powershell
Install-Module -Name ModuleBuild -Scope CurrentUser
```

## Examples
I started this little framework as a build script for [one of my projects](https://github.com/zloeber/FormatPowershellCode) so you can see it in action there if you like (note that this is a very early version of the build script though). I've since taken that code, made it a bit more generic, and added an initialization routine for new projects. As an exercise I adapted [another older project](https://github.com/zloeber/NLogModule) to use this build script as well. So this framework does work for me but you might need to do some tweaking to get it working for your own project but keep in mind that any module that exports more than functions will take additional work. (See the notes below to better understand why.)

## Contributing
[Notes on contributing to this project](Contributing.md)

## Change Log
[Change notes for each release](ChangeLog.md)

## Acknowledgements
[Other projects or sources of inspiration](Acknowledgements.md)


