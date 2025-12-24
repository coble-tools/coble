# Conda Error Troubleshooting

Errors plague the building of conda environments. The default behaviour of `COBLE` is to exit immediately on an error and give the opportunity to fix it. Additionally `COBLE` has built in by default build tools that are commonly the cause of compilter errors.

Generally it is best to install with conda if possible, and then install.packages/BiocManager/pip if not. However note that when moving up to a new version of R the packages may not have been created for conda so you then need to fall back to the native R. This may mnean that to keep a recipe consistent you may want to make it native R instread of conda.

Here follows some common errors, why and how to fix them.  

# Conda dependencies

the main languaes are pinned


# New R version - bioconductor not built


# BiocManager needs underlying conda libs


# Missing compiler tools


