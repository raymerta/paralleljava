#!/bin/bash

#A script to compile and run the additional examples
# Script needs to be in the examples folder
module load jdk-1.8.0_25
module load java-1.8.0_40
module load openmpi-1.8.4

srun -N 1 -n 1 -t 0:10:00 --mem=16384 mpijavac Pi.java
srun -N 1 -n 1 -t 0:10:00 --mem=16384 mpijavac MatrixPar.java

srun -N 1 -n 10 -t 0:10:00 --mem=16384 mpirun -np 10 java Pi
srun -N 1 -n 10 -t 0:10:00 --mem=16384 mpirun -np 10 java MatrixPar