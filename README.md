# compilers

Compiler construction coursework and experiments.

## Overview

This repository gathers educational materials and implementations related to compiler design, parsing, semantic analysis, and LLVM-based tooling.

## Structure

- `compilers-fall-lec*` - course lecture and lab materials
- `eltex` - additional project-specific compiler work
- `README.md` - LLVM/Clang build notes

## LLVM Build Notes

```bash
cmake -S llvm -B build -G Ninja -DCMAKE_BUILD_TYPE=MinSizeRel -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_ENABLE_PROJECTS="clang" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_APPEND_VC_REV=OFF -DLLVM_ENABLE_ASSERTIONS=OFF -DLLVM_ENABLE_ZSTD=OFF -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_ENABLE_LIBXML2=OFF -DLLVM_BUILD_LLVM_DYLIB=OFF -DLLVM_LINK_LLVM_DYLIB=OFF -DLLVM_OPTIMIZED_TABLEGEN=ON -DCMAKE_INSTALL_PREFIX=$HOME/opt/llvm
ninja -C build clang
ninja -C build install
```

## Notes

This repository is a study archive rather than a single production compiler project.

