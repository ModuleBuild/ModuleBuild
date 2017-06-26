function Read-HostContinue {
    param (
        [Parameter(Position=0,HelpMessage='Title for your read prompt.')]
        [String]$PromptTitle = '',
        [Parameter(Position=1,HelpMessage='Question to display at the prompt.')]
        [string]$PromptQuestion = 'Continue?',
        [Parameter(Position=2)]
        [string]$YesDescription = 'Do this.',
        [Parameter(Position=3)]
        [string]$NoDescription = 'Do not do this.',
        [Parameter(Position=4)]
        [switch]$DefaultToNo,
        [Parameter(Position=5)]
        [switch]$Force
    )
    if ($Force) {
        (-not $DefaultToNo)
        return
    }
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", $YesDescription
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", $NoDescription

    if ($DefaultToNo) {
        $ConsolePrompt = [System.Management.Automation.Host.ChoiceDescription[]]($no,$yes)
    }
    else {
        $ConsolePrompt = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    }
    if (($host.ui.PromptForChoice($PromptTitle, $PromptQuestion , $ConsolePrompt, 0)) -eq 0) {
        $true
    }
    else {
        $false
    }
}