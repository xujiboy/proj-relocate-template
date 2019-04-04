#!/bin/bash
env=$1
export PATH="/opt/anaconda/bin:$PATH"

# update conda
conda config --add channels conda-canary
sudo /opt/anaconda/bin/conda update -y -n base -c defaults conda
echo "conda update is done."

# create env
conda create -n ${env} python=3.7 --yes --force
source activate ${env}
conda install cython conda-pack -c conda-forge -y
pip install -r requirement.txt

# pack up env
conda pack -n ${env} -o ${env}.tar.gz

# compile
sudo rm -rf build
python3.7 compile.py build_ext
