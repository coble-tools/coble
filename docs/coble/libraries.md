# Underlying libraries

`COBLE` is purely a highlevel tool that calls third party tools to manage multiple package managers.  

The real work is done behind the scenets in conda, R and python, and the functions called can be controlled through `COBLE` - with simplicity and fdefaults being the first intention.

The `COBLE` directives translate into package bah cmmands and all thed etails fort he different languaes and how the inputs can be controlled are in the langauage speciif c dociments.

## Controlling through conda
Packages can be called through conda or their native package managers. This is how the COBLE directives can be controlled when calling though conda:
`conda library calls TODO`

## Controlling R and BioConductor
When the libraries are controlled through R the inputs have more freedom,, documentation here:
[R package functions in COBLE](r-used.md)
