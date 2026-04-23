Comparing DESeq2 envs in 2020 and 2026 and CRAN v conda
(a versions are package and b versions are conda)

create envs

code/coble build --recipe recipes/demos/ds2/ds2_2020a.cbl --env ds20a --rebuild
code/coble build --recipe recipes/demos/ds2/ds2_2020b.cbl --env ds20b --rebuild
code/coble build --recipe recipes/demos/ds2/ds2_2026a.cbl --env ds26a --rebuild
code/coble build --recipe recipes/demos/ds2/ds2_2026b.cbl --env ds26b --rebuild


The packages are then disentangled

code/coble-disentangle.py recipes/demos/ds2/ds2_2020a_export.cbl recipes/demos/ds2/ds2_2020a_network.txt
code/coble-disentangle.py recipes/demos/ds2/ds2_2020b_export.cbl recipes/demos/ds2/ds2_2020b_network.txt
code/coble-disentangle.py recipes/demos/ds2/ds2_2026a_export.cbl recipes/demos/ds2/ds2_2026a_network.txt
code/coble-disentangle.py recipes/demos/ds2/ds2_2026b_export.cbl recipes/demos/ds2/ds2_2026b_network.txt


And then run for network graph with adjustable settings

python code/coble-plot-network.py recipes/demos/ds2/ds2_2020a_network.txt --hue date --out recipes/demos/ds2/ds2_2020a_network.html
python code/coble-plot-network.py recipes/demos/ds2/ds2_2020b_network.txt --hue date --out recipes/demos/ds2/ds2_2020b_network.html
python code/coble-plot-network.py recipes/demos/ds2/ds2_2026a_network.txt --hue date --out recipes/demos/ds2/ds2_2026a_network.html
python code/coble-plot-network.py recipes/demos/ds2/ds2_2026b_network.txt --hue date --out recipes/demos/ds2/ds2_2026b_network.html
