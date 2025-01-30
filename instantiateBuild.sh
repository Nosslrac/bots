#!/usr/bin/env bash

# Adds required linking and include files to build with custom OpenMP
# runtime library.
# Set environment variable OPENMP_DIR to point to the runtime build directory.

cd ./config

OMP=''
if [ -z "$1" ]; then
    source ~/.bashrc
    if [ -z "$OPENMP_DIR" ]; then 
        echo "OpenMP directory environment variable not set:"
        echo "Set OPENMP_DIR=<path to OpenMP runtime lib> in your ~/.bashrc"
        exit 1
    fi
    OMP=$OPENMP_DIR
else
    OMP=$1
fi

echo "Update config with OpenMP path: $OMP"

if [ -z "$(grep -E "OMPC_FLAGS=.*-I$OMP" ./make.config)" ]; then
    echo "OMP include not found adding include"
    sed -i "s|OMPC_FLAGS=.*$|& -I$OMP|" ./make.config
else
    echo "OMPC_FLAGS already contains OpenMP path"
fi

if [ -z "$(grep -E "OMPLINK_FLAGS=.+?-L$OMP -lomp" ./make.config)" ]; then
    echo "OMP include not found adding include"
    sed -i "s|OMPLINK_FLAGS=.*$|& -L$OMP -lomp|" ./make.config
else
    echo "OMPLINK_FLAGS already contains OpenMP link flags"
fi