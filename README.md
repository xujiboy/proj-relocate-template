# Project Relocate Template

## Intro

This is a simple template for a `python3` project, designed specifically for convenience of relocating or distributing the project from a MacOS system to a Linux system. The motivation behind this template is due to the state of multiple choices of python environment / package management systems (`conda`, `pip`, `virtualenv`, `pipenv`, etc.), and the caveats residing in each of them might cause a perfectly running python project on a MacOS system to be quite difficult to relocate or distribute to another Linux machine. Another common difficulty that developers often face is the lack of internet connection in the target machine (for example on a customer's virtual machine with limited or no internet for security reasons), which makes re-create an identical python environment challenging. Last but not the least, installing `python` on a Linux machine might not seem to be a challenge, but it certainly takes up time from deployment, and can also become a hassle if root access (admin) is not available.

## Highlight

- no need to install `python` on target Linux machine
- automatic local Linux VM management using Vagrant + VirtualBox
- flexibility of choice on python virtual environment management on source / development machine (`pip`, `virtualenv`, `conda`, `pipenv`, etc.)
- utilize `Cython` for compiling project lib (any python packages under directory `lib/`)
- transfer a single tarball file to target Linux machine to distribute the project and re-create an identical virtual environment

## Prerequisite

This template requires these following apps working on the source MacOS machine:

1. [Vagrant](https://www.vagrantup.com/downloads.html) (a VM environment building and managing tool)
2. [VirtualBox](https://www.virtualbox.org/) (a powerful x86 and AMD64/Intel64 virtualization tool)

## Workflow and usage

1. Make sure that Vagrant and VirtualBox are installed and working. Enable guest additions on VirtualBox.
2. Update your project if necessary and make sure that `requirement.txt` is up-to-date.
    - To make this template as simple as possible the structure of the mock project is minimized to only 4 components as shown below.
        1. `makefile`: workflow control
        2. `lib/`: python scripts as importable modules
        3. `bin/`: executable python scripts with command line interfaces
        4. `requirement.txt`: requirement for virtual environment
    - To accommodate different preference of virtual environment management system, only `requirement.txt` is included. To create and invoke a virtual env:
        - if you use `conda` try:

        ``` bash
        conda create -n my_env python=3.7
        conda activate my_env
        pip install -r requirement.txt
        ```

        - if you use `pipenv` try:

        ``` bash
        pipenv --python 3.7
        pipenv install -r requirement.txt
        ```

    - After project update with additional packages installed besides the ones specified in `requirement.txt`, update the `requirement.txt`:
        - with `conda`:

        ``` bash
        conda activate my_env
        pip freeze > requirement.txt
        ```

        - with `pipenv`:

        ``` bash
        pipenv run pip freeze > requirement.txt
        ```

3. run `make all VENV_NAME=your_venv`
    - This will trigger 2 key targets in the makefile:
        1. `compile_linux`
            - Vagrant will provision and create an ubuntu 18.04 machine, download `miniconda` version 4.5.12 (configurable in `compile_linux.sh`) for Linux, and install python 3.7 on the vm. This may take a while if the vm is being created for the first time.
            - `conda` will do a fresh creation of a virtual env called `your_venv` according to the `requirement.txt`
            - `conda-pack` will pack up the virtual env into a tarball `your_venv.tar.gz`
            - Finally `Cython` will cythonize and compile lib scripts in `lib/` into binaries (`.so` files). The lib scripts need to be specified in `compile.py`
        2. `proj_to_distribute.tar.gz`
            - project related files and directed will be copied into `build`, including the packed-up `your_venv.tar.gz`
            - `build` folder will be archived and compressed as `proj_to_distribute.tar.gz` ready to be distributed.
4. transfer `proj_to_distribute.tar.gz` to the target Linux machine, untar it at desired location, and unpack the virtual env (for details on the usage of `conda-pack` refer to its [documentation](https://conda.github.io/conda-pack/)):

    ``` bash
    mkdir -p your_venv
    tar -xzf your_venv.tar.gz -C your_venv
    source your_venv/bin/activate
    ```

    and now you have the identical virtual env as you had on your source machine! To deactivate try:

    ``` bash
    (your_venv) $ source your_venv/bin/deactivate
    ```