# Makefile для запуска LLVM IR

CC = clang
LLC = llc
LLI = lli

.PHONY: all run compile clean

all: gcd

# Компиляция .ll → исполняемый файл
gcd: gcd.ll
	$(LLC) -filetype=obj gcd.ll -o gcd.o
	$(CC) -no-pie gcd.o -o gcd


# Запуск через интерпретатор LLVM (без компиляции)
run:
	$(LLI) gcd.ll

# Очистка
clean:
	rm -f gcd gcd.o gcd.s

# Пересборка
rebuild: clean all