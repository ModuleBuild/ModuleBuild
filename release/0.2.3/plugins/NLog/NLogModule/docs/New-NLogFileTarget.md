---
external help file: NLogModule-help.xml
online version: 
schema: 2.0.0
---

# New-NLogFileTarget

## SYNOPSIS
Creates a new file logging target

## SYNTAX

```
New-NLogFileTarget [[-ArchiveAboveSize] <Int32>] [[-archiveEvery] <String>] [[-ArchiveNumbering] <String>]
 [-CreateDirs] [-FileName] <String> [[-Encoding] <Encoding>] [-KeepFileOpen] [[-Layout] <String>]
 [[-maxArchiveFiles] <Int32>]
```

## DESCRIPTION
Creates a new file logging target

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
TBD
```

## PARAMETERS

### -ArchiveAboveSize
Archives file above this many bytes.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: 10240000
Accept pipeline input: False
Accept wildcard characters: False
```

### -archiveEvery
Period of time to archive log files

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: Month
Accept pipeline input: False
Accept wildcard characters: False
```

### -ArchiveNumbering
How archive files are names

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: Rolling
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateDirs
Create directories when archiving

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

### -FileName
Name of log file

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Encoding
File encoding type

```yaml
Type: Encoding
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: [System.Text.Encoding]::GetEncoding("iso-8859-2")
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeepFileOpen
Maintain a lock on the log file

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
Message layout for logs to the file

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: (Get-NLogMessageLayout -layoutId 1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -maxArchiveFiles
Maximum number of archive files to retain.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 7
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

