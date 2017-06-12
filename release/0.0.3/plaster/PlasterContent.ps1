$Content = @(
    @{
        ContentType = 'newModuleManifest'
        Destination = '${PLASTER_PARAM_ModuleName}.psd1'
        moduleVersion = '${PLASTER_PARAM_ModuleVersion}'
        rootModule = '${PLASTER_PARAM_ModuleName}.psm1'
        copyright = '(c) ${PLASTER_Year} ${PLASTER_PARAM_ModuleAuthor}. All rights reserved.'
        projectURI = '${PLASTER_PARAM_ModuleWebsite}'
        licenseURI = '${PLASTER_PARAM_ModuleWebsite}/raw/master/license.md'
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
        Source = 'scaffold\.gitignore'
        Destination = '.gitignore'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\.gitattributes'
        Destination = '.gitattributes'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\.vscode\*'
        Destination = '.vscode'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\src\other\*'
        Destination = 'src\${PLASTER_PARAM_OtherModuleSource}'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\src\private\*'
        Destination = 'src\${PLASTER_PARAM_PrivateFunctionSource}'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\src\public\*'
        Destination = 'src\${PLASTER_PARAM_PublicFunctionSource}'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\tests\*'
        Destination = 'src\tests'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\build\shutdown\*'
        Destination = 'build\shutdown'
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
        Destination = 'License.md'
        Condition = '$PLASTER_PARAM_ProjectLicense -eq "CreativeCommons"'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\licenses\MIT.md'
        Destination = 'License.md'
        Condition = '$PLASTER_PARAM_ProjectLicense -eq "MIT"'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\licenses\Apache.md'
        Destination = 'License.md'
        Condition = '$PLASTER_PARAM_ProjectLicense -eq "Apache"'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\licenses\GPL.md'
        Destination = 'License.md'
        Condition = '$PLASTER_PARAM_ProjectLicense -eq "GPL"'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\ModuleName.psm1'
        Destination = '${PLASTER_PARAM_ModuleName}.psm1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\modulename.build.ps1'
        Destination = '${PLASTER_PARAM_ModuleName}.build.ps1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\modulename.buildenvironment.ps1'
        Destination = 'build\${PLASTER_PARAM_ModuleName}.buildenvironment.ps1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\modulename.template.json'
        Destination = 'build\${PLASTER_PARAM_ModuleName}.buildenvironment.json'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\readme.md'
        Destination = 'Readme.md'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\Build.ps1'
        Destination = 'Build.ps1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\Install.ps1'
        Destination = 'Install.ps1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\docs\*'
        Destination = 'build\docs'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\docs\ReadTheDocs\*'
        Destination = 'build\docs\ReadTheDocs'
    },
    @{
        ContentType = 'templateFile'
        Source      = 'scaffold\build\docs\en-US\*'
        Destination = 'build\docs\en-US'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\docs\ReadTheDocs\Acknowledgements\*'
        Destination = 'build\docs\ReadTheDocs\Acknowledgements'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\docs\Additional\*'
        Destination = 'build\docs\Additional'
    }
)