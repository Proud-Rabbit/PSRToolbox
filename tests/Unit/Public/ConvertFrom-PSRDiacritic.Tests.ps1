BeforeAll {
    $script:dscModuleName = 'PSRToolkit'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe ConvertFrom-PSRDiacritic {
    Context 'When passing values using named parameters' {
        It 'Should not throw an error' {
            { ConvertFrom-PSRDiacritic -StringIn "ŒœǢöäüßÖÜÄ" } | Should -Not -Throw
            # { ConvertFrom-PSRDiacritic -StringIn "'Œ', 'Oe').Replace('œ', 'oe').Replace('Ǣ', 'Ae').Replace('ö','oe').Replace('ä','ae').Replace('ü','ue').Replace('ß','ss').Replace('Ö','Oe').Replace('Ü','Ue').Replace('Ä','Ae')" } | Should -Not -Throw
            # Should -Invoke -CommandName Get-PrivateFunction -Exactly -Times 1 -Scope It -ModuleName $dscModuleName
        }

        It 'Should return the correct string' {
            $return = ConvertFrom-PSRDiacritic -StringIn "Œuf œuf ǢöäüßÖÜÄ"

            ($return | Measure-Object).Count | Should -Be 1
            $return | Should -Be "Oeuf oeuf AeoaussOUA"
        }

        It 'Given the PHP iconv list should return the correct string' {
            $return = ConvertFrom-PSRDiacritic -StringIn "Š š s Ð Ž  ž À Á Â Ã Ä Å Æ Ç È É Ê Ë Ì Í Î Ï Ñ Ń Ò Ó Ô Õ Ö Ø Ù Ú Û Ü Ý Þ ß à á â ã ä å æ ç è é ê ë ì í î ï ð ñ ń ò ó ô õ ö ø ù ú û ü ý ý þ ÿ ƒ ă î â ș ț Ă Î Â Ș Ț"

            ($return | Measure-Object).Count | Should -Be 1
            $return | Should -Be "S s s Dj Z  z A A A A A A Ae C E E E E I I I I N N O O O O O O U U U U Y B ss a a a a a a ae c e e e e i i i i o n n o o o o o o u u u u y y b y f a i a s t A I A S T"
        }
    }

    Context 'When passing values using alias parameters' {
        It 'Should not throw an error' {
            { ConvertFrom-PSRDiacritic -In "ŒœǢöäüßÖÜÄ" } | Should -Not -Throw
            # { ConvertFrom-PSRDiacritic -StringIn "'Œ', 'Oe').Replace('œ', 'oe').Replace('Ǣ', 'Ae').Replace('ö','oe').Replace('ä','ae').Replace('ü','ue').Replace('ß','ss').Replace('Ö','Oe').Replace('Ü','Ue').Replace('Ä','Ae')" } | Should -Not -Throw
            # Should -Invoke -CommandName Get-PrivateFunction -Exactly -Times 1 -Scope It -ModuleName $dscModuleName
        }

        It 'Should return the correct string' {
            $return = ConvertFrom-PSRDiacritic -In "Œuf œuf ǢöäüßÖÜÄ"

            ($return | Measure-Object).Count | Should -Be 1
            $return | Should -Be "Oeuf oeuf AeoaussOUA"
        }

        It 'Given the PHP iconv list should return the correct string' {
            $return = ConvertFrom-PSRDiacritic -In "Š š s Ð Ž  ž À Á Â Ã Ä Å Æ Ç È É Ê Ë Ì Í Î Ï Ñ Ń Ò Ó Ô Õ Ö Ø Ù Ú Û Ü Ý Þ ß à á â ã ä å æ ç è é ê ë ì í î ï ð ñ ń ò ó ô õ ö ø ù ú û ü ý ý þ ÿ ƒ ă î â ș ț Ă Î Â Ș Ț"

            ($return | Measure-Object).Count | Should -Be 1
            $return | Should -Be "S s s Dj Z  z A A A A A A Ae C E E E E I I I I N N O O O O O O U U U U Y B ss a a a a a a ae c e e e e i i i i o n n o o o o o o u u u u y y b y f a i a s t A I A S T"
        }
    }

    Context 'When passing values over the pipeline' {
        It 'Should return the correct string value from the pipeline' {
            $return = "Œuf œuf ǢöäüßÖÜÄ" | ConvertFrom-PSRDiacritic

            ($return | Measure-Object).Count | Should -Be 1
            $return | Should -Be "Oeuf oeuf AeoaussOUA"
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
                    StringIn = $_
                    OtherProperty = 'other'
                }
            } | ConvertFrom-PSRDiacritic

            $return[0] | Should -Be 'value1'
            $return[1] | Should -Be 'value2'
        }
    }

    # Context 'When passing WhatIf' {
    #     It 'Should support the parameter WhatIf' {
    #         (Get-Command -Name 'ConvertFrom-PSRDiacritic').Parameters.ContainsKey('WhatIf') | Should -Be $true
    #     }

    #     It 'Should not call the private function' {
    #         { ConvertFrom-PSRDiacritic -Data 'value' -WhatIf } | Should -Not -Throw

    #         Should -Invoke -CommandName Get-PrivateFunction -Exactly -Times 0 -Scope It -ModuleName $dscModuleName
    #     }

    #     It 'Should return $null' {
    #         $return = ConvertFrom-PSRDiacritic -Data 'value' -WhatIf

    #         $return | Should -BeNullOrEmpty
    #     }
    # }
}
