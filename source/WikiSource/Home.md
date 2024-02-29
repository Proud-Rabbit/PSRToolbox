# PSRToolkit

![license](https://badgen.net/github/license/Proud-Rabbit/PSRToolbox) ![stable release](https://badgen.net/github/release/Proud-Rabbit/PSRToolbox/stable)

[![nuget](https://badgen.net/badge/icon/packages?icon=nuget&label&color=orange&scale=2)](https://github.com/Proud-Rabbit/PSRToolbox/releases/latest)


## Summary

This module has some exported functions to deal with various tasks that you could find to do in Powershell

| Function                  | Description                                                                                               | Return type |
| ------------------------- | --------------------------------------------------------------------------------------------------------- | :---------: |
| ConvertFrom-PSRDiacritics | Convert a string with diacritics (accents, tildes, ...) to an ASCII string without these diacritics.      |   string    |
| Test-PSRIBAN              | Test if the string given to the function represents a valid IBAN number                                   |   boolean   |
| Test-PSREEAPhoneNumber    | Test if the given string is a valid European Economic Area and some close European neigbours phone number |
