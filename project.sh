#!/bin/bash

#Install open mpi with java
sh OpenMPIjavaRocketInstall.sh

# install tau with java and mpi support
sh TauRocketInstall.sh

cd examples

#compile and run the additional examples
sh RunExamples.sh