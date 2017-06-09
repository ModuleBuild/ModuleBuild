# Step 6 - Start Your Next Release

To start working on your next release (or roll back to a prior release) you will need to update the version.txt file within your project directory. But if you go to build the current module again it will poop out as the version release in this file does not match the version found in your module manifest file. **This is by design**. In order to confirm you are ready to start working on this release you need to run the following.

`.\Build.ps1 -UpdateRelease`

**Note:** *This will spit out an error as we are running the Version task in safe mode and looking for an error. This lets us re-use the task that we use for loading the version number. If the final build shows as succeeded you have nothing to worry about though.*

Once this has been done you can proceed to build your module again:

`.\Build.ps1`

Oh, and if you have been paying attention up to this point you will have seen this coming. You can chain all this crap together into one command:

`.\Build.ps1 -UpdateRelease -NewVersion '0.0.4' -BuildModule -InstallAndTestModule -UploadPSGallery`