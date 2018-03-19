---
external help file: NLogModule-help.xml
online version: 
schema: 2.0.0
---

# Get-NLogMessageLayout

## SYNOPSIS
Sets the log message layout

## SYNTAX

```
Get-NLogMessageLayout [[-layoutId] <Int32>]
```

## DESCRIPTION
Defines, how your log message looks like.
This function can be enhanced by yourself.
I just provided a few examples how log messages can look like

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$myFilelogtarget.Layout  = Get-NLogMessageLayout -layoutId 1
```

## PARAMETERS

### -layoutId
Currently the only defined layout ID is 1.
More can be added to suit your needs.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

