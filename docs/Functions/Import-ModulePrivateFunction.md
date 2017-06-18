---
external help file: ModuleBuild-help.xml
online version: https://github.com/zloeber/ModuleBuild
schema: 2.0.0
---

# Import-ModulePrivateFunction

## SYNOPSIS
Retrieves private module function definitions and recreates them in your modulebuild based project.

## SYNTAX

```
Import-ModulePrivateFunction [[-Path] <String>] [-ModulePath] <String> [[-Name] <String>] [-Force]
```

## DESCRIPTION
Retrieves private module function definitions and recreates them in your modulebuild based project.
This can be used to either upgrade modulebuild for a project or convert an existing module to start using modulebuild.
This function will load and then unload the module to work its magic.
'Private' functions are determined by excluding exported functions and using AST to filter out all function definitions in files within the module folder that are not embedded in other functions.
This function will not overwrite any existing private function file of the same name.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
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
Must be a psd1 file.

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

### -Force
Do not prompt for every function import.

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

## INPUTS

## OUTPUTS

## NOTES
This only applies to modules of the type 'Script'.

## RELATED LINKS

[https://github.com/zloeber/ModuleBuild](https://github.com/zloeber/ModuleBuild)

