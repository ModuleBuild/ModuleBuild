---
external help file: NLogModule-help.xml
online version: 
schema: 2.0.0
---

# New-NLogConsoleTarget

## SYNOPSIS
Creates a new console logging target

## SYNTAX

```
New-NLogConsoleTarget [[-Encoding] <Encoding>] [-ErrorStream] [[-Layout] <String>]
```

## DESCRIPTION
Creates a new console logging target

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
TBD
```

## PARAMETERS

### -Encoding
File encoding type

```yaml
Type: Encoding
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: [System.Text.Encoding]::GetEncoding("iso-8859-2")
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorStream
Enable error stream logging

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

### -Layout
Message layout for logs to the console

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: (Get-NLogMessageLayout -layoutId 3)
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

