---
external help file: ModuleBuild-help.xml
Module Name: ModuleBuild
online version: https://github.com/zloeber/ModuleBuild
schema: 2.0.0
---

# Import-ModulePublicFunction

## SYNOPSIS
Retrieves public module function definitions and recreates them in your modulebuild based project.

## SYNTAX

```
Import-ModulePublicFunction [[-Path] <String>] [-ModulePath] <String> [[-Name] <String>] [-DoNotInsertCBH]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Retrieves module function definitions and recreates them in your modulebuild based project.
This can be used to either upgrade modulebuild for a project or convert an existing module to start using modulebuild.
This function will load and then unload the module to work its magic.

## EXAMPLES

### EXAMPLE 1
```
Import-ModulePrivateFunction -ModulePath 'C:\Temp\PSCloudFlare\release\PSCloudFlare\PSCloudFlare.psd1' -force
```

Finds any non-exported and unembedded functions and automatically creates them in the current modulebuild project private source directory if they don't already exist.

## PARAMETERS

### -Path
Specifies the path to a buildenvironment.json file for an existing modulebuild project.

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

### -ModulePath
An existing module path to target.
Must be a psm1 or psd1 file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
Function name to import.
If none are specified then all functions will be imported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -DoNotInsertCBH
Do not attempt to find and insert comment based help into the function.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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
This only applies to modules of the type 'Script' and commands of the type 'Function'.

## RELATED LINKS

[https://github.com/zloeber/ModuleBuild](https://github.com/zloeber/ModuleBuild)

