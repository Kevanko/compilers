#!/bin/sh

llc --debug-pass=Structure -filetype=obj prog.ll -o prog.o 2> mc.out
#llc --debug-pass=Structure -print-before-all -filetype=obj prog.ll -o prog.o 2> mc.out

# clang -XXX ./prog.c

/usr/bin/ld -o prog "-z" "relro" "--hash-style=gnu" "--eh-frame-hdr" "-m" "elf_x86_64" "-pie" "-dynamic-linker" "/lib64/ld-linux-x86-64.so.2" \
            "/lib/x86_64-linux-gnu/Scrt1.o" "/lib/x86_64-linux-gnu/crti.o" "/usr/lib/gcc/x86_64-linux-gnu/14/crtbeginS.o" \
            "-L/home/mkurnosov/opt/clang/bin/../lib/x86_64-unknown-linux-gnu" "-L/usr/lib/gcc/x86_64-linux-gnu/14" \
            "-L/usr/lib/gcc/x86_64-linux-gnu/14/../../../../lib64" "-L/lib/x86_64-linux-gnu" "-L/lib/../lib64" \
            "-L/usr/lib/x86_64-linux-gnu" "-L/usr/lib64" "-L/lib" "-L/usr/lib" ./prog.o "-lgcc" "--as-needed" \
            "-lgcc_s" "--no-as-needed" "-lc" "-lgcc" "--as-needed" "-lgcc_s" "--no-as-needed" "/usr/lib/gcc/x86_64-linux-gnu/14/crtendS.o" \
            "/lib/x86_64-linux-gnu/crtn.o"

#objdump -D ./prog







