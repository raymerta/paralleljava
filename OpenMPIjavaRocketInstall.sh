#!/bin/bash

# A script to install OpenMPI with Java bindings on Rocket
# Python bindings are also installed and used
# Some example codes are run

# Documentation on MPI and Java can be found at:
# http://charith.wickramaarachchi.org/
# http://www.open-mpi.de/faq/?category=java
# users.dsic.upv.es/~jroman/preprints/ompi-java.pdf
# https://github.com/esaliya/OpenMPI-Java-OMB
# https://cloudmesh.github.io/reu/projects/mpi-java-performance.html
# courses.washington.edu/css434/prog/hw2.pdf
# http://www.i3s.unice.fr/~hogie/mpi4lectures/
# kodu.ut.ee/~eero/pdf/2008/P2P-MPI.pdf

# Docomentation on MPI and Python can be found at:
# http://mpi4py.scipy.org/docs/usrman/index.html
# https://bitbucket.org/mpi4py/mpi4py
# http://ccom.uprrp.edu/~jortiz/cpath/mpi.html#%281%29

cd $HOME

# Load appropriate modules
module purge
module load gcc-4.8.1
module load jdk-1.8.0_25
module load java-1.8.0_40
module load python-2.7.3

# Give installation directory a name
export MPIDIR=OpenMPI
# Make installation directory
mkdir $MPIDIR
# Go into installation directory
cd $MPIDIR
# Get OpenMPI
wget www.open-mpi.org/software/ompi/v1.8/downloads/openmpi-1.8.4.tar.gz
# Decompress OpenMPI
tar -xvf openmpi-1.8.4.tar.gz
# Go into OpenMPI directory
cd openmpi-1.8.4
# Configure it so that it creates Java bindings
./configure --prefix=$HOME/$MPIDIR/install --with-slurm \
            --with-jdk-dir=/storage/software/jdk-1.8.0-25 --enable-mpi-java
# Use an interactive job to compile it, seems to run out of memory on login node
srun -N 1 -t 0:40:00 --mem=16384  make 
# Install the library
srun -N 1 -t 0:40:00 --mem=16384 make install

# Update paths so can use the libraries
export PATH=$HOME/$MPIDIR/install/bin:$PATH
export LD_LIBRARY_PATH=$HOME/$MPIDIR/install/lib:$LD_LIBRARY_PATH

# Go into examples directory
cd examples
# Compile the examples
srun -N 1 -t 0:40:00 --mem=16384 make
# Use interactive jobs to run the examples 
srun -N 1 -n 20 -t 0:10:00 --mem=16384 $HOME/$MPIDIR/install/bin/mpirun -np 20 java Hello
srun -N 1 -n 20 -t 0:10:00 --mem=16384 $HOME/$MPIDIR/install/bin/mpirun -np 20 java Ring

# stop
exit
