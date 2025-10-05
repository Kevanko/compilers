#!/bin/sh

opt --passes=dot-cfg ./prog.ll
for f in `ls *.dot .*.dot`; do
    dot -Tpng -o $f.png ./$f
done

