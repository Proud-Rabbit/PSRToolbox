BeforeAll {
    $script:dscModuleName = 'PSRToolkit'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Test-BelgianBankNumber {
    Context 'When passing an Belgian bank number using named parameters' {
        It 'Should not throw an error' {
            InModuleScope -ModuleName $dscModuleName {
                { Test-BelgianBankNumber -BBAN "123 1234567 84" } | Should -Not -Throw
            }
        }

        It 'Should return true' {
            InModuleScope -ModuleName $dscModuleName {
                $return = Test-BelgianBankNumber -BBAN "123 1234567 84"

                ($return | Measure-Object).Count | Should -Be 1
                $return | Should -BeTrue
            }
        }

        It 'Should return false' {
            InModuleScope -ModuleName $dscModuleName {
                $return = Test-BelgianBankNumber -BBAN "123 1234567 77"

                ($return | Measure-Object).Count | Should -Be 1
                $return | Should -BeFalse
            }
        }
    }

}
