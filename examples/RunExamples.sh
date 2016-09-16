#!/bin/bash

#A script to compile and run the additional examples
# Script needs to be in the examples folder
module load jdk-1.8.0_25
module load java-1.8.0_40

export MPIDIR=OpenMPI
export PATH=$HOME/$MPIDIR/install/bin:$PATH
export LD_LIBRARY_PATH=$HOME/$MPIDIR/install/lib:$LD_LIBRARY_PATH

srun -N 1 -n 1 -t 0:10:00 --mem=16384 $HOME/$MPIDIR/install/bin/mpijavac Pi.java
srun -N 1 -n 1 -t 0:10:00 --mem=16384 $HOME/$MPIDIR/install/bin/mpijavac MatrixPar.java

srun -N 1 -n 10 -t 0:10:00 --mem=16384 $HOME/$MPIDIR/install/bin/mpirun -np 10 java Pi
srun -N 1 -n 10 -t 0:10:00 --mem=16384 $HOME/$MPIDIR/install/bin/mpirun -np 10 java MatrixPar