---
external help file: ModuleBuild-help.xml
Module Name: ModuleBuild
online version: https://github.com/zloeber/ModuleBuild
schema: 2.0.0
---

# Import-ModulePrivateFunction

## SYNOPSIS
Retrieves private module function definitions and recreates them in your modulebuild based project.

## SYNTAX

```
Import-ModulePrivateFunction [[-Path] <String>] [-ModulePath] <String> [[-Name] <String>] [-DoNotInsertCBH]
 [[-ExcludePaths] <String[]>] [[-ExcludeFiles] <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Retrieves private module function definitions and recreates them in your modulebuild based project.
This can be used to either upgrade modulebuild for a project or convert an existing module to start using modulebuild.
This function will load and then unload the module to work its magic.
'Private' functions are determined by excluding exported functions and using AST to filter out all function definitions in files within the module folder that are not embedded in other functions.
This function will not overwrite any existing private function file of the same name.

## EXAMPLES

### EXAMPLE 1
```
Import-ModulePrivateFunction -ModulePath 'C:\Temp\PSCloudFlare\PSCloudFlare.psd1'
```

Finds all the functions that are in the module source but not exported and prompts for each of them to recreate them as individual ps1 files within your ModuleBuild src\private directory.

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
Must be a psd1 or psm1 file.

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
Default for private functions is to skip CBH insertion.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludePaths
Paths within the root of your module source which will be ignored in this import.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: @('temp','build','.git','.vscode','docs','release','plaster')
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeFiles
Files, in regex pattern format, that will be ignored in this import.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: @('.*\.buildenvironment.ps1','.*\.build.ps1','Build\.ps1','Install\.ps1','PreLoad\.ps1','PostLoad\.ps1','.*\.tests\.ps1','.*\.test\.ps1')
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
This only applies to modules of the type 'Script'.
Be very careful before importing everything as any wayward functions might get imported and bloat your resulting module needlessly.

## RELATED LINKS

[https://github.com/zloeber/ModuleBuild](https://github.com/zloeber/ModuleBuild)

