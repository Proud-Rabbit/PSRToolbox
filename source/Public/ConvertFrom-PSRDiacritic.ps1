function ConvertFrom-PSRDiacritic {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]$StringIn
    )

    Process {
        Write-Verbose "Starting with    : $StringIn"

        $StrConv = $StringIn.Replace('Œ', 'Oe').Replace('œ', 'oe').Replace('Ǣ', 'Ae').Replace('ö','oe').Replace('ä','ae').Replace('ü','ue').Replace('ß','ss').Replace('Ö','Oe').Replace('Ü','Ue').Replace('Ä','Ae')
        $formd = $StrConv.Normalize([System.Text.NormalizationForm]::FormD)
        Write-Verbose "Form D Conversion: $formd"
        $sb = New-Object System.Text.StringBuilder
        foreach($char in [char[]]$formd) {
            Write-Verbose "Processing Character $char"
            [System.Globalization.UnicodeCategory]$uc = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($char)
            if($uc -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) {
                $sb.Append($char) | Out-Null
            }
        }
        return $sb.ToString().Normalize([System.Text.NormalizationForm]::FormC)
    }
}