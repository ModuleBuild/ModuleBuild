if ($Script:ModuleBuildLoggingEnabled) {
    UnRegister-NLog
    Remove-Module NlogModule
}