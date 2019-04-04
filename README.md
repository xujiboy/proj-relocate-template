# Project Relocate Template

## Intro
This is a simple tempate for a python3 project, designed specifically for convenience of relocating or distributing from a MacOS system to a Linux system. The motivation behind this template is due to the state of multiple choices of python environment / package management systems (`conda`, `pip`, `virtualenv`, `pipenv`, etc.), and the caveats residing in each of them might cause a perfectly running python project on a MacOS system to be quite difficult to relocate or distribute to another Linux machine. Another common difficulty that developers face is the lack of internet connection in the target machine (for example on a customer's virutual machine with limited or no internet for security reasons), which makes re-create an identical python environment very hard.

## Highlight
- automatic local Linux VM mangement using Vagrant + VirtualBox
- flexibility of choice on python virtual environment management on source / development MacOS machine (`pip`, `virtualenv`, `conda`, `pipenv`, etc.)
- utilize `Cython` for compiling project lib (any python packages under directory `lib/`)
- utilize `conda` and `conda-pack` on target Linux machine to re-create the identical virtual environment

## Prerequisite
This template requires these following apps working on the source MacOS machine:
1. [Vagrant](https://www.vagrantup.com/downloads.html) (a VM environment building and managing tool)
2. [VirtualBox](https://www.virtualbox.org/) (a powerful x86 and AMD64/Intel64 virtualization tool)

## Usage
[TODO]