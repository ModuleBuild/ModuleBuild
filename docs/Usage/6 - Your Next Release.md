# Step 6 - Start Your Next Release

To start working on your next release (or roll back to a prior release) you will need to update the version of your module. This is easily done:

`.\Build.ps1 -NewVersion '0.0.5'`

Once this has been done you can proceed to build your module again:

`.\Build.ps1`

Oh, and if you have been paying attention up to this point you will have seen this coming. You can chain all this crap together into one command:

`.\Build.ps1 -NewVersion '0.0.5' -BuildModule -InstallAndTestModule -UploadPSGallery -ReleaseNotes '0.0.5 release'`

**Note:** It should be noted that performing the InstallAndTestModule build step is a bit superfluous as that gets done prior to uploading to the PSGallery as well. Also, you usually will be working on a release/build a bit before going straight to releasing to the gallery so I generally don't recommend doing everything in one fell swoop like this. You also get a much cleaner build experience if you simply use the invoke-build command to string the build steps together.