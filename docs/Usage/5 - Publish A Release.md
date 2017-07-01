# Step 5 - Upload A PowerShell Gallery Release (Optional)
If you have plans to upload your module to the PowerShell Gallery then this build script can help automate the process a bit. You will still need to create an account and attain an API key from the PowerShell Gallery [website](https://www.powershellgallery.com/).

Once you have attained your API key you will need to update your build configuration file with it. From witin your project root directory do the following:

`Set-BuildEnvironment -NugetAPIKey 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'`

Now when you are ready to upload to the psgallery simply run the following:

`.\Build.ps1 -UploadPSGallery`

Assuming you have a valid NugetAPI key defined and your PowerShell manifest file has everything the gallary requires then this build step will automatically update the the upload the recent release directory module to the PowerShell Gallery for you.

**Note:** *I've not figured out yet how to reset versions when uploading to the gallery. You always have to upload a newer version than what is already there so be extra certain you are ready to publish the module before doing this step.*

Hey, one more point, you can chain things together and do a build, install and test, and upload to the powershell gallery in one fell swoop:

`.\Build.ps1 -BuildModule -InstallAndTestModule -UploadPSGallery -ReleaseNotes 'First Upload'`

or

`Invoke-Build -Task BuildInstallTestAndPublishModule`

or in VS Code

`Ctrl+Shift+B (then select "Build, Install, Test, and Publish Module")`

After this has completed the build version number will automatically be incremented by 1 and updated in your build configuration and the main module manifest file.