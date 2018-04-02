$Content = @(
    @{
        ContentType = 'newModuleManifest'
        Destination = '${PLASTER_PARAM_ModuleName}.psd1'
        moduleVersion = '${PLASTER_PARAM_ModuleVersion}'
        rootModule = '${PLASTER_PARAM_ModuleName}.psm1'
        copyright = '(c) ${PLASTER_Year} ${PLASTER_PARAM_ModuleAuthor}. All rights reserved.'
        projectURI = '${PLASTER_PARAM_ModuleWebsite}'
        licenseURI = '${PLASTER_PARAM_ModuleWebsite}/raw/master/LICENSE.md'
        iconURI = '${PLASTER_PARAM_ModuleWebsite}/raw/master/src/other/powershell-project.png'
        author = '${PLASTER_PARAM_ModuleAuthor}'
        companyname = '${PLASTER_PARAM_ModuleAuthor}'
        description = '${PLASTER_PARAM_ModuleDescription}'
        tags = '${PLASTER_PARAM_ModuleTags}'
        functionsToExport = '*'
        aliasesToExport = ''
        variablesToExport = ''
        encoding = 'UTF8-NoBOM'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\gitignore'
        Destination = '.gitignore'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\gitattributes'
        Destination = '.gitattributes'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\vscode\*'
        Destination = '.vscode'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\github\*'
        Destination = '.github'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\src\other\*'
        Destination = 'src\other'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\src\private\*'
        Destination = 'src\private'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\src\public\*'
        Destination = 'src\public'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\src\templates\*'
        Destination = 'src\templates'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\tests\*'
        Destination = 'src\tests'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\plugins\NLog\*'
        Destination = 'plugins\nlog'
        Condition = '$PLASTER_PARAM_PluginModuleLogging -eq "True"'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\plugins\NLog\NLogModule\*'
        Destination = 'plugins\nlog\NLog\NLogModule'
        Condition = '$PLASTER_PARAM_PluginModuleLogging -eq "True"'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\build\cleanup\*'
        Destination = 'build\cleanup'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\build\startup\*'
        Destination = 'build\startup'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\build\dotsource\*'
        Destination = 'build\dotsource'
    },
    @{
        ContentType = 'file'
        Source      = 'scaffold\build\tools\*'
        Destination = 'build\tools'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\licenses\CreativeCommons.md'
        Destination = 'LICENSE.md'
        Condition = '$PLASTER_PARAM_ProjectLicense -eq "CreativeCommons"'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\licenses\MIT.md'
        Destination = 'LICENSE.md'
        Condition = '$PLASTER_PARAM_ProjectLicense -eq "MIT"'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\licenses\Apache.md'
        Destination = 'LICENSE.md'
        Condition = '$PLASTER_PARAM_ProjectLicense -eq "Apache"'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\licenses\GPL.md'
        Destination = 'LICENSE.md'
        Condition = '$PLASTER_PARAM_ProjectLicense -eq "GPL"'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\ModuleName.template'
        Destination = '${PLASTER_PARAM_ModuleName}.psm1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\modulename.build.template'
        Destination = '${PLASTER_PARAM_ModuleName}.build.ps1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\modulename.buildenvironment.template'
        Destination = 'build\${PLASTER_PARAM_ModuleName}.buildenvironment.ps1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\readme.md'
        Destination = 'Readme.md'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\Build.template'
        Destination = 'Build.ps1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\Install.template'
        Destination = 'Install.ps1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\docs\*'
        Destination = 'build\docs'
    },
    @{
        ContentType = 'templateFile'
        Source      = 'scaffold\build\docs\en-US\about_ModuleName.help.txt'
        Destination = 'build\docs\en-US\about_${PLASTER_PARAM_ModuleName}.help.txt'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\docs\Additional\*'
        Destination = 'build\docs\Additional'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\docs\Additional\*'
        Destination = 'docs'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\docs\ReadTheDocs\*'
        Destination = 'build\docs\ReadTheDocs'
    }
)