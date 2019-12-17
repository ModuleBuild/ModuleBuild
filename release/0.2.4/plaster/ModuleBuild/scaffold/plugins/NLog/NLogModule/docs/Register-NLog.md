---
external help file: NLogModule-help.xml
online version: 
schema: 2.0.0
---

# Register-NLog

## SYNOPSIS
Start NLog logging with a basic configuration.

## SYNTAX

### Default (Default)
```
Register-NLog -FileName <String> [-LoggerName <String>] [-LogLevel <LogLevel>]
```

### TargetSupplied
```
Register-NLog [-LoggerName <String>] [-LogLevel <LogLevel>] -Target <Object>
```

## DESCRIPTION
Start NLog logging with a basic configuration.

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
Parameter Sets: Default
Aliases: 

Required: True
Position: Named
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
Position: Named
Default value: TestLogger
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogLevel
Level of logging.
Default is Info.

```yaml
Type: LogLevel
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: [NLog.LogLevel]::Debug
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
An NLog target (created with New-NLogFileTarget or New-NLogConsoleTarget)

```yaml
Type: Object
Parameter Sets: TargetSupplied
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

