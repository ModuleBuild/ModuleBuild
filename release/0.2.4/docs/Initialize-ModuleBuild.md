---
external help file: ModuleBuild-help.xml
Module Name: ModuleBuild
online version: https://github.com/zloeber/ModuleBuild
schema: 2.0.0
---

# Initialize-ModuleBuild

## SYNOPSIS
Set up the framework for a ModuleBuild project.

## SYNTAX

```
Initialize-ModuleBuild [[-Path] <String>] [[-SourceModule] <String>] [<CommonParameters>]
```

## DESCRIPTION
Set up the framework for a ModuleBuild project.
Optionally supply an existing module manifest path to pull in information from it to begin a migration to ModuleBuild.

## EXAMPLES

### EXAMPLE 1
```
Initialize-ModuleBuild -Path C:\Work\NewModule
```

Prompt for all the settings required to get a new modulebuild project setup in c:\work\NewModule.

### EXAMPLE 2
```
Initialize-ModuleBuild -Path C:\Work\NewModule -SourceModule c:\work\myoldmodule\myoldmodule.psd1
```

Pulls some information from myoldmodule.psd1 and then prompt for any remaining required information to create a modulebuild based project from it in C:\Work\NewModule

Prompt for all the settings required to get a new modulebuild project setup in c:\work\NewModule.

## PARAMETERS

### -Path
Specifies the path to create the project.

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

### -SourceModule
If specified, will import a source module manifest file for module information.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/zloeber/ModuleBuild](https://github.com/zloeber/ModuleBuild)

