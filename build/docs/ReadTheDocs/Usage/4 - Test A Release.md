# Step 4 - Test a Release
You may get a build to complete without errors but that doesn't mean that the module will behave as expected. You can do a quick module install and load test if you like:

`.\Build.ps1 -InstallAndTestModule`

All this does is copy the current build of the project to your user modules at:
`$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules\`

If the module path is already found the build script will attempt to confirm overwriting it. Then it tries to load that version of the module. If you have multiple versions installed in multiple locations you may not get accurate results so be cognizant of this (the location and version of the module is displayed in the output for further investigation).

You can combine the build with the install and test of the module if you so desire:

`.\Build.ps1 -BuildModule -InstallAndTestModule`
