function Get-MBCommonParameter {
    # Helper function to get all the automatically added parameters in an
    # advanced function
    function somefunct {
        [CmdletBinding(SupportsShouldProcess = $true, SupportsPaging = $true, SupportsTransactions = $true)]
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Scope="Function", Target="somefunct",Justification="This is a dummy function in order to get all CommonParameters without hardcoding them. There is no reason for it to actually use SupportsShouldProcess.")]
        param()
    }

    ((Get-Command somefunct).Parameters).Keys
}