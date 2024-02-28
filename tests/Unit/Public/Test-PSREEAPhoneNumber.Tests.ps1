BeforeAll {
    $script:dscModuleName = 'PSRToolkit'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Test-PSREEAPhoneNumber {
    Context 'When passing an bank number using named parameters' {
        It 'Should not throw an error' {
            { Test-PSREEAPhoneNumber -Phone "+32477750663" } | Should -Not -Throw
        }

        It 'Should return true with a correct string' {
            $return = Test-PSREEAPhoneNumber -Phone "+32477750663"
            $return | Should -BeTrue
        }
    }
}
