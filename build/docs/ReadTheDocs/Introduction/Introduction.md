## Introduction
This is a scaffolding framework which can be used to kickstart a generic PowerShell module project. It includes the base files and scripts required to perform regular build releases, uploading to the powershell gallery, and other such fun. All the hard work is done with the excellent invoke-build project engine, a rather large set of build tasks for it, and a custom Plaster template.

The general idea of the base module is that you will develop and test without having to worry about keeping your manifest file up to date with your public functions. When you finally build the module, then the functions are explicitly injected into the manifest file and the source files are all (optionally) combined into one psm1 for distribution.

The starting module is that every private and public function will be saved as separate files in specific directorys (src\public and src\private). Then the module will be build into one monolithic distributable psm1 file with an updated manifect file to reflect your exported functions.

There are a few premises which should be known about this project before using it to start your module development.

- This scaffolding works best with simple script modules where only public functions are being exported. This is largely due to the nature of how modules behave the moment you have to use export-modulemember. When you use this command to export anything then you must also define your functions or none of them will be exported. [This is all defined in the technet article for this command](https://technet.microsoft.com/en-us/library/hh849736.aspx). You can still use this project for some of the many automated benefits it can provide though.

- I use serveral PowerShell 5 features but this doesn't mean that the underlying modules being created need to require PowerShell 5 (the default manifest file that gets created sets the required version to 3).

- Most documentation for the module gets automatically created as part of the build process. This documentation is created from the comment based help associated with every function and from files in the build\docs directory.

## How it Works

Firstly, this module uses everything it creates in its own build process. Since this module is only mildly more complex than a simple script module that works out perfectly.

Aside from the handful of helper functions there is an included 'plaster' folder that includes a customized version of the module of the same name and a manifest folder named ModuleBuild. This ModuleBuild folder contains a scaffold directory structure used to create your projects. The questions asked as well as the actions taken when copying over the scaffold folder items are both contained in the root of the plaster directory in 'plastercontent.ps1' and 'plasterparameters.ps1' and are made into the plaster manifest file at build time.

The scaffolding itself is mostly a big invoke-build script and does not need the ModuleBuild loaded to perform build tasks.

## Folder Structure
A default ModuleBuild project scaffold will look like the following for a project named 'ModuleName' with build version 0.0.1 sucessfully built.
```
ProjectRootFolder
	- .vscode
		settings.json
        tasks.json
	- src
		- other
			preload.ps1
        	postload.ps1
		- public
			Get-PublicFunction1.ps1
        	Set-PublicFunction1.ps1
		- private
			SomePrivateFunction1.ps1
        	SomePrivateFunction2.ps1
	- plugins
		- nlog
    - docs
        index.md
        - Functions
            Get-PublicFunction1.md
            Get-PublicFunction1.md
    - release
        - 0.0.1
        - ModuleName
        	- docs
        	- en-US
        	ModuleName.psm1
            ModuleName.psd1
        ModuleName.zip
        ModuleName-0.0.1.zip
        ModuleName-current.zip
	- build
		- startup
		- shutdown
        - dotsource
        - docs
			- Additional
				Acknowledgements.md
				ChangeLog.md
				Contributing.md
				Index.md
				ReleaseNotes.md
        	- ReadTheDocs
        		- Home
        			index.md
			- EN-us
    			about_ModuleName.help.txt
        ModuleName.buildenvironment.json
        ModuleName.buildenvironment.ps1
	- tests
.gitattributes
.gitignore
Build.ps1
License.md
mkdocs.yml
ModuleName.build.ps1
ModuleName.psd1
ModuleName.psm1
Readme.md

```