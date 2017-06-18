# Contributing to ModuleBuild

Project Site: [https://github.com/zloeber/ModuleBuild](https://github.com/zloeber/ModuleBuild)

There are some important things to be aware of if you plan on contributing to this project.

## Documentation
All base project documentation changes should be made against the .\build\docs\Additional markdown files. These will populate and overwrite existing document files within the .\docs folder at build time. Additionally, you should update the .\build\docs\ReadTheDocs markdown files. Note that each folder becomes its own section within ReadTheDocs and its own folder within the .\docs directory.

Finally, the Function documentation gets generated automatically based on the comment based help on each public/exported function. The function documentation markdown automatically gets populated within the .\docs\Functions folder as well as with the module release under its own docs folder. Private function CBH is not required but is encouraged.

## Development Environment
While any text editor will work well there are included task and setting json files explicitly for Visual Studio Code included with this project. I used VS Code Insiders edition but standard edition should be fine as ewll. The following tasks have been defined to make things a bit easier. First access the 'Pallette' (Shift+Ctrl+P or Shift+Cmd+P)  and start typing in any of the following tasks to find and run them:

- Build -> Runs the Build task (also can use Shift+Ctrl+B or Shift+Cmd+B)
- Analyze -> Runs PSScriptAnalyzer against the src/public files.
- CreateProjectHelp - Creates the project level help.
- InsertMissingCBH - Analyzes the existing public functions and inserts a template CBH if no CBH already exists and saves it into your scratch folder.

The plaster manifest file gets automatically recreated at build time so all you need to do is update the plasterparams.ps1 and/or plastercontent.ps1 in the plaster directory to include any required changes you need to make.

The plaster scaffolding files are largely standard files. But there are some template exceptions that you should be careful not to overwrite (any of the files that dynamically replace content from plaster input at creation time).
