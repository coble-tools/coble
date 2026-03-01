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
echo "docker run -p 8888:8888 -v $(pwd):/opt/conda/envs/basometro your-image jupyter lab \\"
echo "    --ip=0.0.0.0 \\"
echo "    --port=8888 \\"
echo "    --no-browser \\"
echo "    --NotebookApp.token='' \\"
echo "    --NotebookApp.password='' \\"
echo "    --notebook-dir=/opt/conda/envs/basometro/GitHub/mat-basometro \\"
echo "    /opt/conda/envs/basometro/GitHub/mat-basometro/mattree_basometro.ipynb"
echo ""
echo "######### SINGULARITY ENVIRONMENT #########"
echo ""
echo "singularity exec --bind $(pwd):/opt/conda/envs/basometro your-image.sif jupyter lab \\"
echo "    --ip=0.0.0.0 \\"
echo "    --port=8888 \\"
echo "    --no-browser \\"
echo "    --NotebookApp.token='' \\"
echo "    --NotebookApp.password='' \\"
echo "    --notebook-dir=/opt/conda/envs/basometro/GitHub/mat-basometro \\"
echo "    /opt/conda/envs/basometro/GitHub/mat-basometro/mattree_basometro.ipynb"
