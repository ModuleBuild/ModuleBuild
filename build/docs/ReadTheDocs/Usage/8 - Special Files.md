# Special ModuleBuild Files

## src\other

There are two special files in the src\other directory:

**src\other\PreLoad.ps1** - dot sourced at the beginning of the module (and in the build it is the first file to populate the final combined psm1 file).

**src\other\PostLoad.ps1** - dot sourced at the end of the module (and is the last file to populate the final combined psm1 file).

This is meant to help a little with some difference scenarios and could easily be expanded upon (perhaps a different file for exported variables and aliases that are AST parsed and converted into the correct replacements in the final psd1 file?)

- If you are exporting more than just functions (variables, aliases, et cetera) go ahead and put them in your PostLoad.ps1 file with your Export-ModuleMember command. Just remember that the moment you use Export-ModuleMember it will become the dominant preference for exporting functions as well! So ensure you also specify the functions to export when using this command. In this regard maybe think of your manifest file as a filter whenever you use the export-modulemember command but as the actual definition for what gets exported when no export-modulemember command is found ~~(and note that this behavior is ONLY for functions, what a nonsensical design decision...)~~ <-- this does not appear to be the case on my machine, anything that gets exported with the export-modulemember command seems to get exported regardless of what is in the manifest!

- A default skeleton for the module about help txt file is created in a default en-US directory. This file should be updated with a real life example of how to use the module.

## build\dependencies\PSDepend

**build\dependencies\PSDepend\build.depend.psd1** ModuleBuild uses PSDepend to install version tagged modules for its build process. We do this to avoid breaking changes from upstream modules. If you update your build scripts and require other external functions you can add them to this file.