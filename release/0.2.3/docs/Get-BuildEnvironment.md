---
external help file: ModuleBuild-help.xml
Module Name: ModuleBuild
online version: https://github.com/zloeber/ModuleBuild
schema: 2.0.0
---

# Get-BuildEnvironment

## SYNOPSIS
Retrieves all the stored settings in a buildenvironment.json file.

## SYNTAX

```
Get-BuildEnvironment [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves all the stored settings in a buildenvironment.json file.

## EXAMPLES

### EXAMPLE 1
```
Get-buildenvironment
```

If a buildenvironment.json file exists in .\build then the settings within it will be displayed on the screen.
Otherwise nothing happens.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/zloeber/ModuleBuild](https://github.com/zloeber/ModuleBuild)

