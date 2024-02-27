<#
.SYNOPSIS
    Test if the given string is a valid IBAN.
.DESCRIPTION
    Test if the given string is a valid IBAN (Ineternational Bank Account Number).
.PARAMETER IBAN
    The string to be checked to comply as an IBAN
.EXAMPLE
    Test-PSRIBAN -IBAN "BE00 0000 0000 0000"
    Returns true if de IBAN checknumbers are valid, otherwise false
#>
function Test-PSRIBAN
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        # IBAN Number
        [Parameter(
            Mandatory = $true
        )]
        [Alias("AccountNumber")]
        [string] $IBAN
    )


    process
    {
        Write-Verbose ("Given IBAN: {0}" -f $IBAN)
        $str = ($IBAN -replace " ", "" -replace "-", "").ToUpper()

        if (0 -ge $str.Length)
        {
            Write-Verbose "After sanitizing no string is left"
            return $false
        }

        if ($str -notmatch "^(?<country>[A-Z]{2})(?<check>\d{2})(?<bban>\d+)")
        {
            Write-Verbose "Don't match a IBAN string"
            return $false
        }
        $country, $check, $bban = $Matches["country"], $Matches["check"], $Matches["bban"]

        $extra = switch ($country)
        {
            "BE"
            {
                Test-BelgianBankNumber -BBAN $bban
            }
        }

        if (-not $extra)
        {
            Write-Verbose "Fail to pass country specific test"
            return $false
        }

        $str = $bban + $country + "00"

        $ibanInt = New-Object System.Text.StringBuilder
        $str.ToCharArray() | ForEach-Object {
            $retVal = $_
            $iVal = [int]$retVal
            if ((65 -le $iVal) -and (90 -ge $iVal))
            {
                $retVal = "{0:d2}" -f ($iVal - 55)
            }
            $ibanInt.Append($retVal) | Out-Null
        }

        Write-Verbose "Check number is correct?"
        $retVal = ([Int]::Parse($check) -eq (98 - [UInt64]::Parse($ibanInt.ToString()) % 97))
        Write-Verbose $retVal
        $retVal
    }
}
