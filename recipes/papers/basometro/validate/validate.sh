#!/usr/bin/env bash

echo "Validate the basometro recipe by running the jupyter notebook"
echo "  due to missing input data we are first generating a dummy fequency matrix to run the code"
echo "The notebook should run without errors and generate outputs"
echo "When the data has been included the dummy frequency matrix should be replaced with the real one and the notebook should be re-run to validate the full pipeline"
ECHO "This data is at: $CONDA_PREFIX/GitHub/mat-basometro/preprocessing/freq_matrix_Bolsonaro_1.csv"

cp $CONDA_PREFIX/bin/freq_matrix_Bolsonaro_1.csv $CONDA_PREFIX/GitHub/mat-basometro/preprocessing/freq_matrix_Bolsonaro_1.csv

HOME_FOLDER=$(pwd)
echo "To run the jupyter notebook do the following which will open a locally hosted web server"

echo "######### CONDA ENVIRONMENT #########"
echo ""
echo "  jupyter lab --notebook-dir=$CONDA_PREFIX/GitHub/mat-basometro $CONDA_PREFIX/GitHub/mat-basometro/mattree_basometro.ipynb"
echo ""
echo "######### DOCKER ENVIRONMENT #########"
echo ""
echo " docker run -p 8888:8888 ghcr.io/coble-tools/coble:papers-basometro bash -c \""
echo "     /opt/conda/envs/basometro/bin/python -m ipykernel install \\"
echo "         --name=mat-basometro \\"
echo "         --display-name='Python (mat-basometro)' \\"
echo "         --prefix=/opt/conda/envs/basometro && \\"
echo "     /opt/conda/envs/basometro/bin/jupyter lab \\"
echo "         --ip=0.0.0.0 \\"
echo "         --port=8888 \\"
echo "         --no-browser \\"
echo "         --allow-root \\"
echo "         --ServerApp.token='' \\"
echo "         --ServerApp.password='' \\"
echo "         --notebook-dir=/opt/conda/envs/basometro/GitHub/mat-basometro"
echo " \""
echo ""