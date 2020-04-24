# Step 1 - Initialization
Simply download this project and run the Initialize-MBModuleBuild exported function. You will be prompted for a destination folder and the rest of the project settings. The destination folder will be the home of your future project but is completely portable. This is simply a wrapper for a custom version of Plaster that calls a template file I created for the project. It is fairly simple to deconstruct and use plaster directly via invoke-plaster and pass all the parameters via command line if desired.

`Import-Module ModuleBuild`

`Initialize-MBModuleBuild`

or

`Initialize-MBModuleBuild -Path 'c:\temp\mymodule'`


Once this has been kicked off and all answers have been entered, the initialization of your new project directory will start. Several template files are copied out to appropriate locations. Additionally, the default module manifest file gets created.

**Note:** *Much of the ModuleBuild initial settings are not set in stone. If you do make changes to something like the included directories, or other settings which you would like to ensure others have access to when building your project you will have to update them in build\YourModuleName.buildenvironment.ps1*

## Quick Start
With your new module folder all created there are several steps still left to take in order to make your new project more world class. There are several sections of the following documentation that go over fleshing out the module with public functions, building a release, testing things, out and starting another release. Here are some quick next step tips if you aren't feeling like reading all of that.

1. Add public functions, one per file, to '.\src\public'
2. Update your default readme.md file at the root project directory
3. Update the about_ModuleName.help.txt file within '.\build\docs\en-US'
4. Doing ReadTheDocs integration? Cool, update '.\build\docs\ReadTheDocs' by creating folders representing sections and putting markdown files within them for the pages within those sections.
5. But remember that the markdown files in '.\build\docs\Additional' need some love too. These get dropped into your project '.\docs' directory at build time (overwriting anything there in the process!)
6. Update any bits within your *.psd1 that are appropriate to your module but don't mess with the exported function names as those get handled automatically when you do the build.
7. If you enabled sensitive terminology scanning then review and update your terms defined in your '.\build\YourModule.buildenvironment.json' file or use the 'Set-MBBuildEnvironment.ps1' function.
8. Change your project logo at '.\src\other\powershell-project.png'
9. Build your project with '.\Build.ps1'
10. Enter a PowerShell Gallery (aka Nuget) API key to the '.\build\YourModule.buildenvironment.json' file or use the 'Set-MBBuildEnvironment.ps1' function. Without this you will not be able to upload your module to the PSGallery.