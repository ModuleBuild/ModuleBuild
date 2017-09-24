# Converting to ModuleBuild

If you want to convert your existing module to a modulebuild based project then there are a few functions that have been created to help you along. These are a bit new and should be considered a feature in testing.

## Public Functions: Import-ModulePublicFunction

Assuming your existing module is loadable it is pretty simple to determine public functions and then search through all of the module code for them. That is what this function will do. Once the public function has been found it will then (by default) attempt to insert the bare minimum comment based help necessary for PlatyPS to be able to autogenerate the module documentation and save the file into your ModuleBuild project public directory (as defined by your modulebuild project definition file).

This will not overwrite any files that exist by the same name.

## Private Functions: Import-ModulePrivateFunction

Private functions within a module are infinately more tricky to isolate. But based on what is exported and what we find within the module source directory, it is not impossible to guess some of the private functions at least. That is what Import-ModulePrivateFunction command will do. It will always prompt you before importing any found top-level function (that isn't in the list of exported functions).

Like the public function import, this will not overwrite any files that exist in your public source directory.

## General Process

So in order to convert an existing project to a modulebuild project you will follow these steps:

1. Initialize a new ModuleBuild project folder
2. ~~**Build** the project (**and it will fail the first time**). This ensures that your modulebuild project settings have been exported at least once.~~
3. From your new modulebuild project folder run the Import-ModulePrivateFunction command against your existing module.
4. From your new modulebuild project folder run the Import-ModulePublicFunction command against your existing module.
5. Add any required preload or postload code in src\other\preload.ps1 or src\other\postload.ps1

## Very Important Notes
- This will generally work well for easy projects. Modules with many dependencies or higher complexity levels will likely be more work to get converted.
- It is very important that, when specifying your module source, that you choose the right file. There are BIG differences in behavior between importing a psm1 file and a psd1 file and whichever one you pass in will be the one that gets imported.
- I'd only run these commands against a newly initialized project but you could theoretically use this to split up some monolithic module for development purposes. Conversely, you could also use these to merge the public/private functions of multiple disperate modules as well.
- These helper functions are also to be used for migrating existing modulebuild projects to updated versions of modulebuild in the future. All you have to copy over from an existing modulebuild project after importing the private/public functions is the json configuration file, your preload/postload customizations, and additional paths.
- If you tend to use your module project directories as dumping grounds for ideas and scratch code you may want to clean things up a bit before importing your private functions. Otherwise you could be in for a long process of yes/no prompts.