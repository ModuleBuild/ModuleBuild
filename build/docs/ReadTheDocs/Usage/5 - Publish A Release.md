# Step 5 - Upload A PowerShell Gallery Release (Optional)

If you have plans to upload your module to the PowerShell Gallery then this build script can help automate the process a bit. You will still need to create an account and attain an API key from the PowerShell Gallery [website](https://www.powershellgallery.com/).

Once you have attained your API key you will need to update your build configuration file with it. From witin your project root directory open the following file:
`build\YourModuleName.buildenvironment.json`

Here you are able to update the NugetAPIKey.

```json
...
    "FirstRun":  false,
    "NugetAPIKey":  "Add-Your-Key-Here",
    "OptionTranscriptLogFile":  "BuildTranscript.Log",
...
```

**Note:** *Don't add the NugetAPIKey to the `build\YourModuleName.buildenvironment.ps1` file. This file is NOT ignored by the included .gitignore.*

Now when you are ready to upload to the PSGallery simply run the following:

`.\Build.ps1 -UploadPSGallery`

Assuming you have a valid NugetAPI key defined and your PowerShell manifest file has everything the PSGallary requires then this build step will automatically update the the upload the recent release directory module to the PowerShell Gallery for you.

**Note:** *I've not figured out yet how to reset versions when uploading to the gallery. You always have to upload a newer version than what is already there so be extra certain you are ready to publish the module before doing this step.*
