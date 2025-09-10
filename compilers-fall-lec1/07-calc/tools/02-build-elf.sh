#!/bin/bash

# Compiles LLVM IR (bytecode) into assembly language for a specified architecture
llc -march=x86-64 -O3 -filetype=obj -relocation-model=pic -o=calc.o ./calc.ll

# Linking calc with RTL
clang -o calc.x ./calc.o ../src/rtl/rtcalc.c

