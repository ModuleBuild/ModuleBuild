---
external help file: ModuleBuild-help.xml
Module Name: ModuleBuild
online version: https://github.com/zloeber/ModuleBuild
schema: 2.0.0
---

# Add-PublicFunction

## SYNOPSIS
Adds a public function to your modulebuild based project based on defined templates.

## SYNTAX

```
Add-PublicFunction [[-Name] <String>] [-Force] [-TemplateName <String>] [<CommonParameters>]
```

## DESCRIPTION
Adds a public function to your modulebuild based project.

## EXAMPLES

### EXAMPLE 1
```
Add-PublicFunction -Name 'New-AwesomeFunction' -TemplateName:PlainPublicFunction
```

## PARAMETERS

### -Name
Name of the function to add.
Must use a valid PowerShell verb-action format and be singular.

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

### -Force
Ignore function name best practices warnings.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TemplateName
Use this template file for the new function

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

