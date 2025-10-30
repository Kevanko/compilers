#!/bin/sh

# Compiler Gcd.mod --> Gcd.o
./tinylang --filetype=obj Gcd.mod

# Link Gcd.o (_t3Gcd3GCD()) with callgcd.o (main()) -- C module calls Module-2 module
clang callgcd.c Gcd.o -o gcd

#./gcd

