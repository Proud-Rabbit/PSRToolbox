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
function ConvertFrom-PSRDiacritic
{
    [cmdletbinding()]
    [OutputType([string])]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('In')]
        [string]$StringIn
    )

    Process
    {
        Write-Verbose "Starting with    : $StringIn"

        $formd = $StringIn.Normalize([System.Text.NormalizationForm]::FormD)
        Write-Verbose "Form D Conversion: $formd"
        $sb = New-Object System.Text.StringBuilder
        foreach ($char in [char[]]$formd)
        {
            Write-Verbose "Processing Character $char"
            [System.Globalization.UnicodeCategory]$uc = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($char)
            if ($uc -ne [System.Globalization.UnicodeCategory]::NonSpacingMark)
            {
                $sb.Append($char) | Out-Null
            }
        }

        # Convert other characters that doesn't have NonSpacingMarks
        $StrConv = $sb.ToString().Replace([String][char]0x00c6, 'Ae').Replace([String][char]0x00de, 'B').Replace([String][char]0x00d0, 'Dj').Replace([String][char]0x00d8, 'O').Replace([String][char]0x0152, 'Oe').Replace([String][char]0x00e6, 'ae').Replace([String][char]0x00fe, 'b').Replace([String][char]0x0192, 'f').Replace([String][char]0x00f0, 'o').Replace([String][char]0x00f8, 'o').Replace([String][char]0x0153, 'oe').Replace([String][char]0x00df, 'ss')
        return $StrConv.Normalize([System.Text.NormalizationForm]::FormC)
    }
}
