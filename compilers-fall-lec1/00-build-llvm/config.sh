#!/bin/sh

cmake -S llvm -B build -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLLVM_USE_LINKER=lld \
      -DLLVM_ENABLE_PROJECTS="clang;lld;openmp" -DCMAKE_INSTALL_PREFIX=$HOME/opt/clang





