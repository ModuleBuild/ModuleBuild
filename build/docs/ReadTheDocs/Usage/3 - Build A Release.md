# Step 3 - Build a Release

The default version for a brand new module is set at 0.0.1. To build this module for a release simply run the Build.ps1 file

`.\Build.ps1`

or

`.\Build.ps1 -BuildModule`

This is the heart of the ModuleBuild project. The build will go through the process of combining the source files into a monolithic psm1 file, populating the exportable functions of the release module manifest, creating online help files, analyze the script, scan for sensitive terms, and more. If everything builds without errors you will see the results populated in the release directory in two areas:
1. In the release directory in a folder with the same name as the module (which is best practice for a module)
2. In the release directory in a folder with the version number of the release.

**Note**: *If you run the build process again it will overwrite the version and current directory.*

At this point you should have a working release you could theoretically have someone manually install if you so desired.

**Note:** *The build will pause if you didn't have enough comment based help to create the help file. Now is a chance to look at the created markdown files it references in the temp\docs directory to see what is missing. Use this as a chance to round back on your CBH in the source function files and update it to fill in the gaps. Then restart the build process again. Alternately, you can update the markdown files directly then continue the build process but this is NOT recommended as it is a temporary solution at best.*