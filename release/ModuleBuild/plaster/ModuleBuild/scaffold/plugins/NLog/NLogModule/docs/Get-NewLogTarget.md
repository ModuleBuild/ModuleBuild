﻿---
external help file: NLogModule-help.xml
online version: 
schema: 2.0.0
---

# Get-NewLogTarget

## SYNOPSIS
Creates a new logging target

## SYNTAX

```
Get-NewLogTarget [-TargetType] <String>
```

## DESCRIPTION
Logging targets are required to write down the log messages somewhere

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$myFilelogtarget = Get-NewLogTarget -targetType "file"
```

## PARAMETERS

### -TargetType
Type of target to return, Console, file, or mail are supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

