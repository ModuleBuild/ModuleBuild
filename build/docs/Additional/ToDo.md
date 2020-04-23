# ModuleBuild ToDo List

Project Site: [https://github.com/zloeber/ModuleBuild](https://github.com/zloeber/ModuleBuild)

There are many items which are possible and should probably be added to this project. Here are a few thoughts on ones I'll probably get addressed sooner or later. I'm open to suggestions or pull requests.

- Update the sensitive parameter scans to be a pester test instead
- Add pre-gallary deployment pester tests for any files that will cause issues or cause the psscript analyzer at the gallery to fail (so files beginning with a period will not transfer, ps1 files in extra directories will cause analyzer failures, et cetera)
- ~~Create functions to pull functions from another module (function only) and recreate them in the current module project directory would be cool.~~
- Better git tasks?
- Include more useful base pester tests for standard modules
- ~~Automatic module version update options if uploading to the gallery~~
- Automatic clean up of additional loaded modules when uploading to the gallery
- Powershell Core compatibility
- Automatic updates of the ReleaseNotes.md file
- Appveyor integration?
- PSDeploy integration?
- Github releases integration?
- Smoother path to upgrade ModuleBuild for existing projects
