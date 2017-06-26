function Get-CommonParameters {
    # Helper function to get all the automatically added parameters in an
    # advanced function
    function somefunct {
        [CmdletBinding(SupportsShouldProcess = $true, SupportsPaging = $true, SupportsTransactions = $true)]
        param()
    }

    ((Get-Command somefunct).Parameters).Keys
}