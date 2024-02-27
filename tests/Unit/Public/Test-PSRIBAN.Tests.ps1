BeforeAll {
    $script:dscModuleName = 'PSRToolkit'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Test-PSRIBAN {
    Context 'When passing an bank number using named parameters' {
        It 'Should not throw an error' {
            { Test-PSRIBAN -IBAN "BE03 123 1234567 84" } | Should -Not -Throw
        }

        It 'Should return true with a correct string' {
            $return = Test-PSRIBAN -IBAN "BE03 1231 2345 6784"
            $return | Should -BeTrue
        }

        It 'Should return false with an incorrect string (dashes)' {
            $return = Test-PSRIBAN -IBAN "---------"
            $return | Should -BeFalse
        }

        It 'Should return false with an incorrect string (To much alphabet chars)' {
            $return = Test-PSRIBAN -IBAN "BEBE 1231 2345 6784"
            $return | Should -BeFalse
        }

        It 'Should return false with an incorrect string (country)' {
            $return = Test-PSRIBAN -IBAN "BE95 1231 2345 6777"
            $return | Should -BeFalse
        }
    }
}
