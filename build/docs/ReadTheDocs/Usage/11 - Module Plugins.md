# Module Plugins

As of version 0.1.7 template module plugins are supported. These are optional plugins chosen when initializing new module projects that add extra functionality to the resulting module project.

Currently the following plugins are available:

## NLog
This includes all the code needed to automatically log all of the following commands within your module:

- Write-Host
- Write-Verbose
- Write-Output
- Write-Debug
- Write-Error
- Write-Warning

The log file will automatically be written to the loading user's $ENV:TEMP\<modulename>.log file when the module is loaded (and stop when the module is unloaded).

Be careful with this one as **ALL** output from the commands mentioned will be logged. This may not be your intent. You can alter the behavior of this plugin as you see fit by changing the code in plugins\NLog\Load.ps1 and plugins\NLog\UnLoad.ps1.
