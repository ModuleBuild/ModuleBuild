---
external help file: ModuleBuild-help.xml
Module Name: ModuleBuild
online version: https://github.com/zloeber/ModuleBuild
schema: 2.0.0
---

# Set-BuildEnvironment

## SYNOPSIS
Sets a stored setting in a buildenvironment.json file.

## SYNTAX

```
Set-BuildEnvironment [[-Path] <String>] [-AdditionalModulePaths <Object[]>] [-BaseReleaseFolder <String>]
 [-BaseSourceFolder <String>] [-BuildReportsFolder <String>] [-BuildToolFolder <String>] [-Encoding <String>]
 [-FirstRun <Boolean>] [-Force <Boolean>] [-ForceInstallModule <Boolean>] [-FunctionTemplates <String>]
 [-ModuleAuthor <String>] [-ModuleCopyright <String>] [-ModuleDescription <String>]
 [-ModuleLicenseURI <String>] [-ModuleTags <Object[]>] [-ModuleToBuild <String>] [-ModuleVersion <String>]
 [-ModuleWebsite <String>] [-NugetAPIKey <String>] [-OptionAnalyzeCode <Boolean>]
 [-OptionCodeHealthReport <Boolean>] [-OptionCombineFiles <Boolean>] [-OptionGenerateReadTheDocs <Boolean>]
 [-OptionRunPlatyPSVerbose <Boolean>] [-OptionSanitizeSensitiveTerms <Boolean>]
 [-OptionSensitiveTerms <Object[]>] [-OptionSensitiveTermsInitialized <Boolean>]
 [-OptionTranscriptEnabled <Boolean>] [-OptionTranscriptLogFile <String>]
 [-OptionUpdateVersionAfterPublishing <Boolean>] [-OtherModuleSource <String>]
 [-PrivateFunctionSource <String>] [-PublicFunctionSource <String>] [-ScratchFolder <String>]
```

## DESCRIPTION
Sets the stored setting in a buildenvironment.json file.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-BuildEnvironment -OptionSensitiveTerms @('myapikey','myname','password')
```

## PARAMETERS

### -Path
Specifies the path to a buildenvironment.json file.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -AdditionalModulePaths
Update the setting for AdditionalModulePaths

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -BaseReleaseFolder
Update the setting for BaseReleaseFolder

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -BaseSourceFolder
Update the setting for BaseSourceFolder

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -BuildReportsFolder
Update the setting for BuildReportsFolder

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -BuildToolFolder
Update the setting for BuildToolFolder

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Encoding
Update the setting for Encoding

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -FirstRun
Update the setting for FirstRun

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Force
Update the setting for Force

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ForceInstallModule
Update the setting for ForceInstallModule

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -FunctionTemplates
Update the setting for FunctionTemplates

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ModuleAuthor
Update the setting for ModuleAuthor

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ModuleCopyright
Update the setting for ModuleCopyright

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ModuleDescription
Update the setting for ModuleDescription

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ModuleLicenseURI
Update the setting for ModuleLicenseURI

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ModuleTags
Update the setting for ModuleTags

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ModuleToBuild
Update the setting for ModuleToBuild

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ModuleVersion
Update the setting for ModuleVersion

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ModuleWebsite
Update the setting for ModuleWebsite

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -NugetAPIKey
Update the setting for NugetAPIKey

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OptionAnalyzeCode
Update the setting for OptionAnalyzeCode

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OptionCodeHealthReport
Update the setting for OptionCodeHealthReport

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OptionCombineFiles
Update the setting for OptionCombineFiles

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OptionGenerateReadTheDocs
Update the setting for OptionGenerateReadTheDocs

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OptionRunPlatyPSVerbose
Update the setting for OptionRunPlatyPSVerbose

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OptionSanitizeSensitiveTerms
Update the setting for OptionSanitizeSensitiveTerms

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OptionSensitiveTerms
Update the setting for OptionSensitiveTerms

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OptionSensitiveTermsInitialized
Update the setting for OptionSensitiveTermsInitialized

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OptionTranscriptEnabled
Update the setting for OptionTranscriptEnabled

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OptionTranscriptLogFile
Update the setting for OptionTranscriptLogFile

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OptionUpdateVersionAfterPublishing
Update the setting for OptionUpdateVersionAfterPublishing

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OtherModuleSource
Update the setting for OtherModuleSource

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PrivateFunctionSource
Update the setting for PrivateFunctionSource

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PublicFunctionSource
Update the setting for PublicFunctionSource

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ScratchFolder
Update the setting for ScratchFolder

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/zloeber/ModuleBuild](https://github.com/zloeber/ModuleBuild)

