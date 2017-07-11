# Maintaining Project Documentation
Keeping documentation updated for your project comes in two forms with the module code scaffolding that this project creates.

1. You keep your comment based help for public functions updated. PlatyPS will use this to generate function documentation.
2. ReadTheDocs manifest creation and updating for ReadTheDocs.org integration.

Your module documentation also comes in a few different forms and locations that are important to know ahead of time.

1. **Project documentation** - This is the docs folder at the root of your project. This is fully generated from your build\docs folder and automatically from PlatyPS at each build.
2. **Module documentation (distributed)** - This is packaged within your module release docs folder. This is essentially just a trimmed down version of your project documentation that only includes your module function documentation and little else. This is used to create your downloadable documentation (a cab file) and is also used as a point in time documentation for specific versions of your module.
3. **Module documentation (downloadable)** - This is distributed with the module in the en-US folder and includes the local cab/zip/xml files for local module help.

>**NOTE:** If you get one thing from this section it is that you should **NOT** be updating your project documentation in the .\docs folder directly. Instead, use the build\docs folder to update your documentation and it will automatically populate to your project .\docs directory at build time.

## Comment Based Help (aka. CBH)
This build project assumes that the comment based help in your public functions are the single source of truth for your documentation.

ModuleBuild uses PlatyPS to generate the relevant help files at every build. The build will fail if "{{ blah blah blah }}" is found within the PlatyPS markdown output. PlatyPS puts this marker text in place when you have missed parameters, synopsis, descriptions, or other essential CBH sections.

It is possible to setup the build process in a manner that would allow us to manually make updates to the .md files and then continue processing. But I've purposefully decided against this so you are encouraged to go back to your original functions, fix/change the offending CBH, and rebuild.

Once PlatyPS autodocumentation is complete the CBH for each function gets replaced with the generated module documentation link. I base this replacement code on '.SYNOPSIS' existing in the comment based help. This is done in the following task:
```
task UpdateCBH -Before CreateModulePSM1 {
    $CBHPattern = "(?ms)(\<#.*\.SYNOPSIS.*?#>)"
    Get-ChildItem -Path "$($ScratchPath)\$($PublicFunctionSource)\*.ps1" -File | ForEach {
            $FormattedOutFile = $_.FullName
            Write-Output "      Replacing CBH in file: $($FormattedOutFile)"
            $UpdatedFile = (get-content  $FormattedOutFile -raw) -replace $CBHPattern, $ExternalHelp
            $UpdatedFile | Out-File -FilePath $FormattedOutFile -force -Encoding:utf8
     }
}
```

As you might expect this will remove the entire CBH block which may or may not be what you want in your final release (Update: I've included code to also include the external link based on the version release directory and module website).

>**NOTE:** ModuleBuild recreates the documentation markdown files every time the documentation gets generated. This includes the module landing page. PlatyPS doesn't seem to automatically pull in function description information (or I'm missing something in the usage of this module) so I do so within another task behind the scenes.

## CBH Helper
I've included a special task called 'UpdateCBHToScratch' that will recurse through your public functions and look for those that don't have CBH and add it. These files get spit out to your scratch directory and can be inspected for possible reintegration into your project. You can run this process at anytime with the following switch:

`.\Build.ps1 -InsertCBH`

If you have a large project with little CBH this can be a good way to kickstart the process so the build process will start working. Additionally, if you add a bunch of public functions without CBH you can use this process to fill things out temporarily until you have time to round back and add better details.

>**NOTE:** This process requires you to copy the resulting files back into your project to be of any use.

## Generic Documentation
Most of your documentation will come from two sources, the auto-generated function markdown that PlatyPS spits out and the build\docs\Additional folder.

## ReadTheDocs.org Integration
If you have enabled readthedocs.org integration in the ModuleBuild configuration then a mkdocs.yml file will get updated automatically at the root of your project directory. It is up to you to setup the integration between your github.com account and readthedocs.org for this to be of any use in your project. When setting up your project at the ReadTheDocs website remember to set the advanced settings for 'mkdocs' processing.

### ReadTheDocs YAML Configuration
The ReadTheDocs manifest file gets generated from three locations:

1. The folder structure in .\build\docs\ReadTheDocs - Each subfolder becomes a category with each markdown document within becoming a specific page within it.
2. The markdown files in .\build\docs\Additional - Each file is placed at the root of your pages section in the finished yaml file.
3. Markdown files auto-generated by PlatyPS for each function. These get copied over to docs\Functions at every build.

Beware that the order of the pages in this manifest file can be rather random. You will want to update the file to suit your needs (and then possibly disable readthedocs integration within your ModuleBuild config file so it doesn't revert the next build you run).

**mkdocs.yml needs to be manually removed if you want it to be entirely regenerated**