#!/bin/sh

clang -S -emit-llvm prog.c -o prog.ll
