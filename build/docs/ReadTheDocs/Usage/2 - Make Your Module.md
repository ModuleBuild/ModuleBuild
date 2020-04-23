# Step 2 - Flesh Out Your Module

After the initialization has completed this directory should be all setup and 'buildable' without much more work needed other than adding your ps1 files to the right directories.

## Adding Public Functions

Any exportable/public functions for your module should be dropped into the .\src\public folder. Ideally each function will be self contained with a file name that matches the function name. Any other private functions can be dropped into .\src\private.

You can easily add a new public function using templates of your own devising with the `Add-PublicFunction` command. To add a new public function with a rather bare template function run the following:

`Add-PublicFunction -Name 'New-TestFunction' -TemplateName:PlainPublicFunction`

The allowed template names are dynamically pulled directly from the module src\templates directory. Look in this folder for an example template and feel free to add more of your own to suit your project needs.

## Pre/Post Module Code

There are a few special files within .\src\other that allow you to run code at the top or bottom of your module. These are necessary for having a transformative build process (so you can import the module without building for testing, then later build the module into a single file automatically and have things work the same).

## Test Without Building

At this point maybe you just want to load the module to see how things are going without going through a long build process. To do this simply import the module psm1 file.

**Note:** *If you import the module without any public code at all (right after initializing for example) then the only private function I include with this template always gets exported for whatever reason (get-callerpreference). Because of this I purposefully error out of the build process if no public functions are defined.*

Anyways, load up your module for testing by importing the .psm1 file if you like:
`Import-Module .\ModuleName.psm1`

It will work as you would expect where any defined functions in the public folder will be exported and everything else will remain private to the module.

***Note**: The install.ps1 script that gets generated automatically creates github appropriate links for downloading your project. You may have to modify the install.ps1 if your project is located elsewhere.*

You should also probably update the default readme.md file that gets created as it is rather bland.