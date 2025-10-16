# Пути к инструментам (если у тебя LLVM в ~/opt/llvm/bin, укажи явно)
LLI      ?= lli
CLANG    ?= clang
CFLAGS   = -O0

# Файлы
C_SRC    = gcd.c
LL_AUTO  = gcd_auto.ll
LL_MANUAL = gcd.ll
BIN_AUTO = gcd_auto
BIN_MANUAL = gcd_manual

.PHONY: all auto manual run-auto run-manual clean

all: auto manual

# Сгенерировать LLVM IR из C (без оптимизаций)
auto: $(LL_AUTO)

$(LL_AUTO): $(C_SRC)
	$(CLANG) -S -emit-llvm $(CFLAGS) $< -o $@

# Собрать исполняемый файл из автоматического IR
$(BIN_AUTO): $(LL_AUTO)
	$(CLANG) $< -o $@

# Собрать исполняемый файл из ручного IR
$(BIN_MANUAL): $(LL_MANUAL)
	$(CLANG) $< -o $@

# Запуск через интерпретатор LLVM
run-auto: $(LL_AUTO)
	$(LLI) $<

run-manual: $(LL_MANUAL)
	$(LLI) $<

# Собрать оба бинарника
manual: $(BIN_MANUAL)

# Очистка
clean:
	rm -f $(LL_AUTO) $(BIN_AUTO) $(BIN_MANUAL)

# Удобная цель: всё собрать и запустить
test: run-manual run-auto