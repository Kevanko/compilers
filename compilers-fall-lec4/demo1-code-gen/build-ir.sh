#!/bin/sh

for f in `ls *.mod`; do
    ./tinylang --filetype=asm --emit-llvm -o $f.ll $f
done
