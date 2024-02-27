<#
.SYNOPSIS
    Test if a string is a Belgian bank number.
.DESCRIPTION
    Test if a string is a Belgian bank number.
.PARAMETER BBAN
    BBAN on the country specific bank number part of a IBAN
.EXAMPLE
    Test-BelgianBankNumber -BBAN "123 1234567 84"
    Return true if it is a Belgian bank number, false otherwise
#>
function Test-BelgianBankNumber
{
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        # BBAN number
        [Parameter(
            Mandatory = $true
        )]
        [String]
        $BBAN
    )

    process
    {
        if ($BBAN -notmatch "^\d{3}[\s-]?\d{7}[\s-]?\d{2}$")
        {
            Write-Verbose "String not recognised as a Belgian bank number"
            return $false
        }
        $str = ($BBAN -replace " ", "" -replace "-", "")
        $num = [Int64]::Parse($str.Substring(0, 10))
        $check = [Int64]::Parse($str.Substring(10))
        $check -eq ((($num - 1) % 97) + 1)
    }
}
