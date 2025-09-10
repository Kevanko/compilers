#!/bin/bash

mkdir build
cd build
cmake .. -DLLVM_DIR=$HOME/opt/llvm/lib/cmake/llvm
make

cd ..
cp -f build/src/calc tools/
