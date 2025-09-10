#!/bin/sh

opt --passes=dot-cfg ./test.ll
dot -Tpng -o image.png ./.main.dot