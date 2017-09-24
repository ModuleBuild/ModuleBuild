---
external help file: NLogModule-help.xml
online version: 
schema: 2.0.0
---

# Register-NLog

## SYNOPSIS
Register the NLog dlls and create a file logging target.

## SYNTAX

```
Register-NLog [-FileName] <String> [[-LoggerName] <String>]
```

## DESCRIPTION
Register the NLog dlls and create a file logging target.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Register-NLog -FileName C:\temp\testlogger.log
```

## PARAMETERS

### -FileName
File to start logging to

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

### -LoggerName
An Nlog name (useful for multiple logging targets)

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: TestLogger
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

