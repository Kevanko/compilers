#!/bin/sh

opt --print-pipeline-passes -O1 -S prog.ll -o prog_opt.ll
