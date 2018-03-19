﻿---
external help file: NLogModule-help.xml
online version: http://go.microsoft.com/fwlink/?LinkId=821881
schema: 2.0.0
---

# Write-Warning

## SYNOPSIS
Writes a warning message.
Writes a warning message.

## SYNTAX

```
Write-Warning [-Message] <String>
```

## DESCRIPTION
The Write-Warning cmdlet writes a warning message to the Windows PowerShell host.
The response to the warning depends on the value of the user's $WarningPreference variable and the use of the WarningAction common parameter.

The Write-Warning cmdlet writes a warning message to the Windows PowerShell host.
The response to the warning depends on the value of the user's $WarningPreference variable and the use of the WarningAction common parameter.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
write-warning "This is only a test warning."
```

This command displays the message "WARNING: This is only a test warning."

### -------------------------- EXAMPLE 2 --------------------------
```
$w = "This is only a test warning."
```

PS C:\\\>$w | write-warning
This example shows that you can use a pipeline operator (|) to send a string to Write-Warning.
You can save the string in a variable, as shown in this command, or pipe the string directly to Write-Warning.

### -------------------------- EXAMPLE 3 --------------------------
```
$warningpreference
```

Continue

PS C:\\\>write-warning "This is only a test warning."
This is only a test warning.

PS C:\\\>$warningpreference = "SilentlyContinue"
PS C:\\\>write-warning "This is only a test warning."
PS C:\\\>
PS C:\\\>$warningpreference = "Stop"
PS C:\\\>write-warning "This is only a test warning."

WARNING: This is only a test message.
Write-Warning : Command execution stopped because the shell variable "WarningPreference" is set to Stop.
At line:1 char:14
+ write-warning \<\<\<\<  "This is only a test message."
This example shows the effect of the value of the $WarningPreference variable on a Write-Warning command.
The first command displays the default value of the $WarningPreference variable, which is "Continue".
As a result, when you write a warning, the warning message is displayed and execution continues.
When you change the value of the $WarningPreference variable, the effect of the Write-Warning command changes again.
A value of "SilentlyContinue" suppresses the warning.
A value of "Stop" displays the warning and then stops execution of the command.
For more information about the $WarningPreference variable, see about_Preference_Variables.

### -------------------------- EXAMPLE 4 --------------------------
```
write-warning "This is only a test warning." -warningaction Inquire
```

WARNING: This is only a test warning.
Confirm
Continue with this operation?
\[Y\] Yes  \[A\] Yes to All  \[H\] Halt Command  \[S\] Suspend  \[?\] Help (default is "Y"):
This example shows the effect of the WarningAction common parameter on a Write-Warning command.
You can use the WarningAction common parameter with any cmdlet to determine how Windows PowerShell responds to warnings resulting from that command.
The WarningAction common parameter overrides the value of the $WarningPreference only for that particular command.
This command uses the Write-Warning cmdlet to display a warning.
The WarningAction common parameter with a value of "Inquire" directs the system to prompt the user when the command displays a warning.
For more information about the WarningAction common parameter, see about_CommonParameters.

### Example 1: Write a warning message
```
PS C:\>Write-Warning "This is only a test warning."
```

This command displays the message "WARNING: This is only a test warning."

### Example 2: Pass a string to Write-Warning
```
PS C:\>$w = "This is only a test warning."
PS C:\>$w | Write-Warning
```

This command shows that you can use a pipeline operator (|) to send a string to Write-Warning .
You can save the string in a variable, as shown in this command, or pipe the string directly to Write-Warning .

### Example 3: Set the $WarningPreference variable and write a warning
```
PS C:\>$warningpreference
Continue PS C:\>Write-Warning "This is only a test warning."
This is only a test warning. PS C:\>$warningpreference = "SilentlyContinue"
PS C:\>Write-Warning "This is only a test warning."
PS C:\>
PS C:\>$warningpreference = "Stop"
PS C:\>Write-Warning "This is only a test warning."
WARNING: This is only a test message. 
Write-Warning : Command execution stopped because the shell variable "WarningPreference" is set to Stop. 
At line:1 char:14
     + Write-Warning <<<<  "This is only a test message."
```

This example shows the effect of the value of the $WarningPreference variable on a Write-Warning command.

The first command displays the default value of the $WarningPreference variable, which is Continue.
As a result, when you write a warning, the warning message is displayed and execution continues.

When you change the value of the $WarningPreference variable, the effect of the Write-Warning command changes again.
A value of SilentlyContinue suppresses the warning.
A value of Stop displays the warning and then stops execution of the command.

For more information about the $WarningPreference variable, see about_Preference_Variables.

### Example 4: Set the WarningAction parameter and write a warning
```
PS C:\>Write-Warning "This is only a test warning." -WarningAction Inquire
WARNING: This is only a test warning. 
Confirm
Continue with this operation? 
 [Y] Yes  [A] Yes to All  [H] Halt Command  [S] Suspend  [?] Help (default is "Y"):
```

This example shows the effect of the WarningAction common parameter on a Write-Warning command.
You can use the WarningAction common parameter with any cmdlet to determine how Windows PowerShell responds to warnings resulting from that command.
The WarningAction common parameter overrides the value of the $WarningPreference only for that particular command.

This command uses the Write-Warning cmdlet to display a warning.
The WarningAction common parameter with a value of Inquire directs the system to prompt the user when the command displays a warning.

For more information about the WarningAction common parameter, see about_CommonParameters.

## PARAMETERS

### -Message
Specifies the warning message.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Msg

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

### System.String

### System.String
You can pipe a string that contains the warning to Write-Warning .

## OUTPUTS

### None

### None
Write-Warning writes only to the warning stream.
It does not generate any other output.

## NOTES
The default value for the $WarningPreference variable is "Continue", which displays the warning and then continues executing the command.
To determine valid values for a preference variable such as $WarningPreference, set it to a string of random characters, such as "abc".
The resulting error message will list the valid values.

* The default value for the $WarningPreference variable is Continue, which displays the warning and then continues executing the command. To determine valid values for a preference variable such as $WarningPreference, set it to a string of random characters, such as "abc". The resulting error message will list the valid values.

*

## RELATED LINKS

[Write-Debug]()

[Write-Error]()

[Write-Host]()

[Write-Information]()

[Write-Output]()

[Write-Progress]()

[Write-Verbose]()

