# Step 1 - Initialization
Simply download this project and run the Initialize-ModuleBuild exported function. You will be prompted for a destination folder and the rest of the project settings. The destination folder will be the home of your future project but is completely portable. This is simply a wrapper for a custom version of Plaster that calls a template file I created for the project. It is fairly simple to deconstruct and use plaster directly via invoke-plaster and pass all the parameters via command line if desired.

`Import-Module ModuleBuild`

`Initialize-ModuleBuild`

or

`Initialize-ModuleBuild -Path 'c:\temp\mymodule'`


Once this has been kicked off and all answers have been entered, the initialization of your new project directory will start. Several template files are copied out to appropriate locations. Additionally, the default module manifest file gets created.

**Note:** *Much of the ModuleBuild initial settings are not set in stone. If you do make changes to something like the included directories, or other settings which you would like to ensure others have access to when building your project you will have to update them in build\YourModuleName.buildenvironment.ps1*

## Quick Start
With your new module folder all created there are several steps still left to take in order to make your new project more world class. There are several sections of the following documentation that go over fleshing out the module with public functions, building a release, testing things, out and starting another release. Here are some quick next step tips if you aren't feeling like reading all of that.

1. Add public functions, one per file, to .\src\public (You can use the ModuleBuild function 'Add-PublicFunction' for this task)
2. Update your default readme.md file at the root project directory
3. Update the about_ModuleName.help.txt file within .\build\docs\en-US
4. Doing ReadTheDocs integration? Cool, update .\build\docs\ReadTheDocs by creating folders representing sections and putting markdown files within them for the pages within those sections.
5. But remember that the markdown files in .\build\docs\Additional need some love too. These get dropped into your project .\docs directory at every build (overwriting anything there in the process!)
6. Update any bits within your *.psd1 that are appropriate to your module but don't mess with the exported function names as those get handled automatically when you do the build.
7. If you enabled sensitive terminology scanning then review and update your terms defined in your buildenvironment.json file (using get-buildenvironment & set-buildenvironment).
8. Build your project with by running .\Build.ps1, running the build task in VS Code, or running Invoke-Build at your project root.
9. If you have ReadTheDocs integration enabled make sure to re-organize the generated mkdocs.yml to be ordered how you like before pushing your code to github.
