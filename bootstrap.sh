conda=/opt/anaconda/bin/conda
miniconda=Miniconda3-4.5.12-Linux-x86_64.sh

cd /vagrant
if [[ ! -f $conda ]]
then
    echo "conda not found"
    if [[ ! -f $miniconda ]]; then
        wget --quiet https://repo.anaconda.com/miniconda/$miniconda
    fi
    echo "install conda"
    chmod +x $miniconda
    ./$miniconda -b -p /opt/anaconda
    rm $miniconda
else
    echo "conda found"
fi