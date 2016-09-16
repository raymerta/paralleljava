#!/bin/bash

cd $HOME

# Load appropriate modules
module purge
module load gcc-4.8.1
module load jdk-1.8.0_25
module load java-1.8.0_40
module load zlib-1.2.6
module load libpng-1.5.10


export PROFILINGDIR=profiling
export TAUDIR=tau
#Download ptd
wget www.cs.uoregon.edu/research/tau/pdt_releases/pdt-3.20.tar.gz 
tar -xvf pdt-3.20.tar.gz 
cd pdtoolkit-3.20/

./configure -prefix=$HOME/$PROFILINGDIR/$TAUDIR/pdtinstall
make
make install
cd ..
# Download the modified tau tarball
wget http://tau.uoregon.edu/tau2.tgz
tar -xvf tau2.tgz

cd tau2/

# Configure binutils
./configure -bfd=download
# Configure tau using jdka 1.8 and mpi with java bindings
./configure -useropt='-std=gnu++11' -jdk=/storage/software/jdk-1.8.0-25 -bfd=download -mpiinc=$HOME/$MPIDIR/install/include/ -mpilib=$HOME/$MPIDIR/install/lib/ -prefix=$HOME/$PROFILINGDIR/$TAUDIR/tau2install -pdt=$HOME/$PROFILINGDIR/$TAUDIR/pdtinstall
make install

export LD_LIBRARY_PATH=$HOME/$MPIDIR/install/lib:$LD_LIBRARY_PATH
export PATH=$HOME/$PROFILINGDIR/$TAUDIR/tau2install/x86_64/bin:$PATH

cd ..
cd tau2install/examples/java/pi

srun -N 1 -n 4 -t 0:10:00 --mem=16384 tau_java Pi 20000000
mv profile.0.0.1 profile.0.0.0
pprof