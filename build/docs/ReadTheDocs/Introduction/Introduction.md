## Introduction
This is a scaffolding framework which can be used to kickstart a generic PowerShell module project. It includes the base files and scripts required to perform regular build releases, uploading to the powershell gallery, and other such fun. All the hard work is done with the excellent invoke-build project engine, a rather large set of build tasks for it, and a custom Plaster template.

There are a few premises which should be known about this project.

- This scaffolding works best with simple script modules where only public functions are being exported. This is largely due to the nature of how modules behave the moment you have to use export-modulemember. When you use this command to export anything then you must also define your functions or none of them will be exported. [This is all defined in the technet article for this command](https://technet.microsoft.com/en-us/library/hh849736.aspx). You can still use this project for some of the many automated benefits it can provide, that is if you are willing to massage things a little bit.

- I use serveral PowerShell 5 features but this doesn't mean that the underlying modules being created need to require PowerShell 5 (the default manifest file that gets created sets the required version to 3).

- Most documentation for the module gets automatically created as part of the build process. This documentation is created from the comment based help associated with every function. I personally find this to be the easiest way to keep my documentation up to date. All the code and tasks are open to be changed though. The beauty of a task based engine like invoke-build is that you can very easily use the existing tasks and create your own customizations.

- Parts of this scaffolding were written specifically around the premise that the project is hosted in github.

- The general idea of the base module is that you will develop and test it out without having to worry about keeping your manifest file up to date with your public functions. When you finally build the module, then the functions are explicitly injected into the manifest file and the source files are all (optionally) combined into one psm1 for distribution.

- I've included a handful of other tasks that can be run directly with invoke-build. This includes testing out the documentation generation and code formatting. They are not included in the wrapper script at this time as it felt a bit like recreating a wheel (becase invoke-build is so easy to use as it is).

## Folder Structure
A default ModuleBuild project scaffold will look like the following for a project named 'ModuleName' with build version 0.0.1 sucessfully built.
```
ProjectRootFolder
	- .vscode
		settings.json
        tasks.json
    - EN-us
    	about_ModuleName.help.txt
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
		- cleanup
        - dotsource
        - docs
			- Additional
        	- ReadTheDocs
        		- Home
        			index.md
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