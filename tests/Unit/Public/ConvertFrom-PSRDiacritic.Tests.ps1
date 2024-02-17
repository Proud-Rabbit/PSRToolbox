BeforeAll {
    $script:dscModuleName = 'PSRToolkit'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe ConvertFrom-PSRDiacritic {
    BeforeAll {
        Mock -CommandName Get-PrivateFunction -MockWith {
            # This return the value passed to the Get-PrivateFunction parameter $PrivateData.
            $PrivateData
        } -ModuleName $dscModuleName
    }

    Context 'When passing values using named parameters' {
        It 'Should call the private function once' {
            { ConvertFrom-PSRDiacritic -StringIn "ŒœǢöäüßÖÜÄ" } | Should -Not -Throw
            # { ConvertFrom-PSRDiacritic -StringIn "'Œ', 'Oe').Replace('œ', 'oe').Replace('Ǣ', 'Ae').Replace('ö','oe').Replace('ä','ae').Replace('ü','ue').Replace('ß','ss').Replace('Ö','Oe').Replace('Ü','Ue').Replace('Ä','Ae')" } | Should -Not -Throw

            
            # Should -Invoke -CommandName Get-PrivateFunction -Exactly -Times 1 -Scope It -ModuleName $dscModuleName
        }

        It 'Should return a single string' {
            $return = ConvertFrom-PSRDiacritic -StringIn "Œuf œuf ǢöäüßÖÜÄ"

            ($return | Measure-Object).Count | Should -Be 1
            "Oeuf oeuf AeoeaeuessOeUeAe".Equals($return) | Should -BeTrue
        }

        It 'Should return the correct string value' {
            $return = ConvertFrom-PSRDiacritic -Data 'value'

            $return | Should -Be 'value'
        }
    }

    Context 'When passing values over the pipeline' {
        It 'Should call the private function two times' {
            { 'value1', 'value2' | ConvertFrom-PSRDiacritic } | Should -Not -Throw

            Should -Invoke -CommandName Get-PrivateFunction -Exactly -Times 2 -Scope It -ModuleName $dscModuleName
        }

        It 'Should return an array with two items' {
            $return = 'value1', 'value2' | ConvertFrom-PSRDiacritic

            $return.Count | Should -Be 2
        }

        It 'Should return an array with the correct string values' {
            $return = 'value1', 'value2' | ConvertFrom-PSRDiacritic

            $return[0] | Should -Be 'value1'
            $return[1] | Should -Be 'value2'
        }

        It 'Should accept values from the pipeline by property name' {
            $return = 'value1', 'value2' | ForEach-Object {
                [PSCustomObject]@{
                    Data = $_
                    OtherProperty = 'other'
                }
            } | ConvertFrom-PSRDiacritic

            $return[0] | Should -Be 'value1'
            $return[1] | Should -Be 'value2'
        }
    }

    Context 'When passing WhatIf' {
        It 'Should support the parameter WhatIf' {
            (Get-Command -Name 'ConvertFrom-PSRDiacritic').Parameters.ContainsKey('WhatIf') | Should -Be $true
        }

        It 'Should not call the private function' {
            { ConvertFrom-PSRDiacritic -Data 'value' -WhatIf } | Should -Not -Throw

            Should -Invoke -CommandName Get-PrivateFunction -Exactly -Times 0 -Scope It -ModuleName $dscModuleName
        }

        It 'Should return $null' {
            $return = ConvertFrom-PSRDiacritic -Data 'value' -WhatIf

            $return | Should -BeNullOrEmpty
        }
    }
}