# Step 4 - Test a Release
You may get a build to complete without errors but that doesn't mean that the module will behave as expected. You can do a quick module install and load test if you like:

`.\Build.ps1 -InstallAndTestModule`

All this does is copy the current build of the project to your user modules at:
`$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules\`

If the module path already exists, the build script will ask for confirmation before overwriting it. Afterwards, the that version of the module is imported to ensure it imports without issues. If you have multiple versions installed in multiple locations you may not get accurate results so be cognizant of this (the location and version of the module is displayed in the output for further investigation).

You can combine the build with the install and test of the module if you so desire:

`.\Build.ps1 -BuildModule -InstallAndTestModule`

or

`Invoke-Build -Task BuildInstallAndTestModule`

or in VS Code

`Ctrl+Shift+B (then select "Build, Install, and Test Module")`