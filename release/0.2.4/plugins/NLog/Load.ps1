if ($Script:ModuleBuildLoggingEnabled) {
    Import-Module (Join-Path $MyModulePath 'plugins\nlog\nlogmodule\0.0.2\nlogmodule.psd1') -Force -Scope:Global
    Register-NLog -FileName (Join-Path $ENV:TEMP 'ModuleBuild.log') -LoggerName 'ModuleBuild'
}