# ModuleBuild
A scaffolding framework which can be used to kickstart a generic PowerShell module project.

Project Site: [https://github.com/zloeber/ModuleBuild](https://github.com/zloeber/ModuleBuild)

## What is ModuleBuild?
A scaffolding framework which can be used to kickstart a generic PowerShell module project.

## Why use the ModuleBuild Module?
The answer is simple, it takes all the hard work out of authoring and maintaining your PowerShell module.

### Features
This build framework for PowerShell modules comes with several appealing baked in features and more are  easy to add. Some features include;
- Fully portable project directory structure and build process. So portable that you can copy it to another PowerShell 5.0 capable system and it should run the same.
- Includes ability to scan for sensitive terms (like your company domain name or other items that you may not want published)
- Automatically combine your public and private functions into one clean psm1 file at build time.
- Automatically update your psd1 file with public functions at build time.
- Automatically scan your module release with PSScriptAnalyzer
- Automatically upload your script to the PowerShell Gallery (with appropriate API key)

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

## Contributing
[https://github.com/zloeber/ModuleBuild/docs/Contributing.md](https://github.com/zloeber/ModuleBuild/docs/Contributing.md)

## Release Notes
[https://github.com/zloeber/ModuleBuild/docs/ReleaseNotes.md](https://github.com/zloeber/ModuleBuild/docs/ReleaseNotes.md)

## Change Log
[https://github.com/zloeber/ModuleBuild/docs/ChangeLog.md](https://github.com/zloeber/ModuleBuild/docs/ChangeLog.md)

## Acknowledgements
[https://github.com/zloeber/ModuleBuild/docs/Acknowledgements.md](https://github.com/zloeber/ModuleBuild/docs/Acknowledgements.md)

