<#
.SYNOPSIS
    Test the validity of the phone as a EEA phone number
.DESCRIPTION
    Test the validity of the phone as a European Economic Area (EEA) phone number in ITU-T E.164 format.
    (Also see https://www.itu.int/rec/T-REC-E.164/)
.NOTES
    Only Belgian payed phone numbers are also excluded to be valid.
    This to prevent usage of the number causing extra cost.
.PARAMETER Phone
    Test the validity of the phone as a EEA phone number
.EXAMPLE
    Test-PSREEAPhoneNumber -Phone "+3212121212"
    Will return true
#>
function Test-PSREEAPhoneNumber
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param (
        [Parameter(
            Mandatory = $true
        )]
        [String]
        $Phone
    )

    process
    {
        ($Phone -match "^\+(3((0[0-9]{10})|([134][0-9]{9})|(2(?!7[07]|90[0-79])[1-9][0-9]{7,9})|5([0267][0-9]{8}|1[0-9]{9}|[349][0-9]{7,9}|8[0-9]{5,12})|6[0-9]{8,9}|7([01][0-9]{8}|2[0-9]{7})|8(5[0-9]{8,9}|6[0-9]{8})|9[0-9]{6,12})|4(([018][0-9]{9}|2([01][0-9]{9}|3[0-9]{7,12})|3[0-9]{4,13}|4[0-9]{7,10}|5[0-9]{8}|6[0-9]{6,9}|7[0-9]{4,12}|9((([25-7][21]1[0-9]{2})|(2((0[1-39][0-9]{2})|(151[0-9])|(28[0-9]{2})|(3[14][0-9]{2})|(41[0-9]{2})))|(3((0[0-9]{3})|(3(082|81[0-9]))|([457]1[0-9]{2})))|(4((0[0-9]{3})|(21[0-9]{2})))|(6((071[0-9])|(9[0-9]{3})))|(8((21[0-9]{2})|(9[0-9]{3})))|(911[0-9]{2}))[0-9]{3,4}))))$")
    }

}
