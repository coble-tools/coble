The order is chronological
The inconsistencies in loads is not accidental, sometimes a bioconductor loads through conda, sometimes through R
It seems that it doesn't load through conda when you are trying to force a version it doesn't like though, my theory

There are 3 main types of loading
conda
R (bioconductor, devtools, direct packages)
Cran archives - R CMD INSTALL ....... after wget

# Steps
1. Is to install this package through mamba using the new script I have created so I can set it going and don;t have to wtach.
2. Rationalise the order and build in some methods of trying first conda then another method if it fails.
3. Try to get all bioconductor packages loading through conda first.
4. Try to get all CRAN packages loading through conda first.
5. Only use R to load bioconductor packages that are not available through conda
6. Then reorder into blocks of conda, bioconductor, cran, python
