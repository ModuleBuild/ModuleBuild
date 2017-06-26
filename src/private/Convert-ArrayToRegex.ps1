function Convert-ArrayToRegex {
    # Takes an array of strings and turns it into a regex matchable string
    [CmdletBinding()]
    param(
        [parameter(Position = 0, ValueFromPipeline = $TRUE)]
        [String[]]$Item,
        [parameter(Position = 1)]
        [Switch]$DoNotEscape
    )
    begin {
        $Items = @()
    }
    process {
        $Items += $Item
    }
    end {
        if ($Items.Count -gt 0) {
            if ($DoNotEscape) {
                '^(' + ($Items -join '|') + ')$'
            }
            else {
                '^(' + (($Items | %{[regex]::Escape($_)}) -join '|') + ')$'
            }
        }
        else {
            '^()$'
        }
    }
}