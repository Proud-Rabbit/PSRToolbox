<#
.SYNOPSIS
    Convert a diacritic containing string to diacriticless string
.DESCRIPTION
    Convert a diacritic containing string (with accents, cedille, ...) and dual chars to diacriticless string
    This is handy to transform a string of an E-mail for example that is supported by the most mail infrastructures.
.PARAMETER StringIn
    String that should be dedicritisized.
.NOTES
    I suspect that I don't have listed all possible dual characters
.EXAMPLE
    ConvertFrom-PSRDiacritic -StringIn "Œuf élève één coördinatie"
    Returns "Oeuf eleve een coordinatie"
.EXAMPLE
    "Œuf élève één coördinatie" | ConvertFrom-PSRDiacritic
    Returns "Oeuf eleve een coordinatie"
#>
function ConvertFrom-PSRDiacritic {
    [cmdletbinding()]
    param (
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
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
