# Лабораторная работа №5: Трансляция массивов и записей в LLVM IR

## Содержание
1. [Введение](#введение)
2. [Подготовка окружения](#подготовка-окружения)
3. [Тест 1: Массивы в TinyLang](#тест-1-массивы-в-tinylang)
4. [Тест 2: Записи (RECORD) в TinyLang](#тест-2-записи-record-в-tinylang)
5. [Тест 3: Структуры в C/Clang](#тест-3-структуры-в-cclang)
6. [Тест 4: Константные выражения в определении массивов](#тест-4-константные-выражения-в-определении-массивов)
7. [Итоговые выводы](#итоговые-выводы)

## Введение

**Цель работы**: исследовать трансляцию конструкций работы с массивами и записями (struct) из Modula-2 в LLVM IR, сравнить поведение TinyLang и Clang при генерации кода для составных типов.

## Подготовка окружения

### Шаг 1. Сборка проекта TinyLang

```bash
cd ~/Study/compilers/compilers-fall-lec5/tinylang
mkdir -p build
cd build
cmake ..
make -j$(nproc)
```

**Примечание:**
Основные компоненты компилятора:
- **Парсер**: `tinylang/lib/Parser/Parser.cpp` (строки 208-232 для ARRAY/RECORD)
- **Семантический анализатор**: `tinylang/lib/Sema/Sema.cpp` (строки 137-206 для типов)
- **Генератор кода**: `tinylang/lib/CodeGen/CGModule.cpp` (строки 52-79 для преобразования типов)

### Шаг 2. Проверка сборки

```bash
cd ~/Study/compilers/compilers-fall-lec5
tinylang/build/tools/driver/tinylang --version
```

**Ожидаемый результат:**
tinylang - Tinylang compiler 0.1
  Default target: x86_64-unknown-linux-gnu
  Host CPU: znver3

## Тест 1: Массивы в TinyLang

### Шаг 3. Создание теста для массива

Создайте файл `array10.mod` с содержимым:

```modula2
MODULE ExampleMod;
TYPE MyArray = ARRAY [10] OF INTEGER;
VAR v: MyArray;
PROCEDURE Main;
BEGIN
  v[2] := 100;
END Main;
END ExampleMod.
```

**Важно:** Используется строго `[10]`, а не выражение, так как генератор кода не поддерживает вычисление константных выражений (см. CGModule.cpp, строки 57-61: `assert(llvm::cast<IntegerLiteral>(Nums) && "Expected an integer literal");`).

### Шаг 4. Генерация LLVM IR

```bash
tinylang/build/tools/driver/tinylang array10.mod --emit-llvm > array10.ll
cat array10.ll
```

**Ожидаемый результат (фрагмент):**
@_t10ExampleMod1v = private global [10 x i64]
define void @_t10ExampleMod4Main() {
entry:
  store i64 100, ptr getelementptr inbounds ([10 x i64], ptr @_t10ExampleMod1v, i32 0, i64 2), align 8
  ret void
}

**Анализ результата:**
- Тип MyArray транслируется в LLVM-тип `[10 x i64]` (строки 52-68 в CGModule.cpp)
- Доступ к элементу массива реализован через инструкцию `getelementptr inbounds`
- В процедуре Main создано 1 базовых блока (entry)
- Массив объявлен как глобальная переменная с типом `[10 x i64]` и инициализирован нулями (по умолчанию)

## Тест 2: Записи (RECORD) в TinyLang

### Шаг 5. Создание теста для записи

Создайте файл `cursor.mod` с содержимым:

```modula2
MODULE RecEx;
TYPE Cursor = RECORD
  visible: BOOLEAN;
  x, y: INTEGER
END;
VAR c: Cursor;
PROCEDURE SetCenter();
BEGIN
  c.visible := TRUE;
  c.x := 100;
  c.y := 100;
END SetCenter;
END RecEx.
```

### Шаг 6. Генерация LLVM IR

```bash
tinylang/build/tools/driver/tinylang cursor.mod --emit-llvm > cursor.ll
cat cursor.ll
```

**Ожидаемый результат (фрагмент):**
%Cursor = type { i1, i64, i64 }
@_t5RecEx1c = private global %Cursor
define void @_t5RecEx9SetCenter() {
entry:
  store i1 true, ptr @_t5RecEx1c, align 1
  store i64 100, ptr getelementptr inbounds (%Cursor, ptr @_t5RecEx1c, i32 0, i32 1), align 8
  store i64 100, ptr getelementptr inbounds (%Cursor, ptr @_t5RecEx1c, i32 0, i32 2), align 8
  ret void
}

**Анализ результата:**
- Разбор конструкции RECORD происходит в Parser.cpp, строки 222-232
- Генерация LLVM-типа происходит в CGModule.cpp, строки 69-79
- Тип Cursor транслируется в `%Cursor = type { i1, i64, i64 }`
- Поля доступны по индексам: 0 → visible, 1 → x, 2 → y
- **Вывод по выравниванию:** Паддинг (байты выравнивания) после поля visible отсутствует. Структура хранится в плотном формате, что видно по отсутствию дополнительных полей или явного указания выравнивания в определении типа.

## Тест 3: Структуры в C/Clang

### Шаг 7. Создание теста для C-структуры

Создайте файл `cstruct.c` с содержимым:

```c
#include <stdint.h>
struct C {
  uint8_t visible;
  uint64_t x, y;
};
int main() {
  struct C c;
  c.visible = 1;
  c.x = 2;
  return 0;
}
```

### Шаг 8. Генерация LLVM IR через Clang

```bash
clang -S -emit-llvm -o - cstruct.c | grep -A15 '%struct\.C'
```

**Ожидаемый результат:**
%struct.C = type { i8, i64, i64 }
...
%1 = alloca %struct.C, align 8
...
%2 = getelementptr inbounds %struct.C, %struct.C* %1, i32 0, i32 0
store i8 1, i8* %2, align 1
%3 = getelementptr inbounds %struct.C, %struct.C* %1, i32 0, i32 1
store i64 2, i64* %3, align 8

**Анализ результата:**
- Clang также не добавляет явные байты выравнивания в определение типа (`%struct.C = type { i8, i64, i64 }`)
- Однако переменная в стеке имеет атрибут `align 8`, гарантирующий 8-байтовое выравнивание структуры
- Доступ к полям имеет различные атрибуты выравнивания: `align 1` для visible и `align 8` для x и y

**Почему нет паддинга?**
- Современные процессоры x86-64 поддерживают не выровненный доступ к памяти (хотя он менее эффективен)
- Clang полагается на выравнивание всей структуры (align 8), а не на изменение layout
- Явный паддинг добавляется только при необходимости строгого соответствия ABI или при использовании `#pragma pack`

## Тест 4: Константные выражения в определении массивов

### Шаг 9. Проверка поддержки выражений в размере массива

Создайте файл `array_expr.mod` с содержимым:

```modula2
MODULE Test;
TYPE MyArray = ARRAY [10 + 4] OF INTEGER;
VAR v: MyArray;
PROCEDURE P; BEGIN END P;
END Test.
```

### Шаг 10. Попытка компиляции

```bash
tinylang/build/tools/driver/tinylang array_expr.mod --emit-llvm
```

**Ожидаемый результат (ошибка):**
tinylang: /home/user/.../CGModule.cpp:61: 
assert(llvm::cast<IntegerLiteral>(Nums) && "Expected an integer literal") failed.

**Анализ причины:**
- Парсер (Parser.cpp, строки 213-221) успешно разбирает выражения в квадратных скобках
- Семантический анализатор (Sema.cpp, строки 137-153) проверяет, что выражение константное и имеет тип INTEGER
- Однако генератор кода (CGModule.cpp, строки 57-61) содержит TODO-комментарий и ожидает только литералы:

```cpp
// TODO Evaluate the constant expression.
assert(llvm::cast<IntegerLiteral>(Nums) && "Expected an integer literal");
```

**Вывод:** Текущая версия TinyLang не поддерживает арифметические выражения в качестве длины массива на этапе генерации кода, несмотря на то, что парсер и семантический анализатор их принимают.

## Итоговые выводы

### Массивы в TinyLang:
- Разбор конструкции ARRAY реализован в Parser.cpp, строки 208-221
- Генерация LLVM-типа массива происходит в CGModule.cpp, строки 52-68
- Для присваивания элементу массива генерируется 1 базовый блок (entry)
- Доступ к элементам реализован через инструкцию `getelementptr inbounds`

### Записи (RECORD) в TinyLang:
- Разбор конструкции RECORD реализован в Parser.cpp, строки 222-232
- Генерация LLVM-типа происходит в CGModule.cpp, строки 69-79
- TinyLang не добавляет байты выравнивания после поля visible (плотная упаковка)
- Доступ к полям записи осуществляется через индексы в `getelementptr`

### Сравнение с C/Clang:
- Clang также не добавляет явный паддинг в определение типа
- Для обеспечения корректного доступа к полям используются атрибуты выравнивания (align 8)
- Причина отсутствия явного паддинга: современные процессоры x86-64 допускают не выровненный доступ к памяти, выравнивание обеспечивается на уровне размещения переменных

### Константные выражения:
- TinyLang частично поддерживает выражения в размере массива:
  - Парсер и семантика принимают выражения
  - Генератор кода требует только целочисленные литералы
- Для полной поддержки необходимо реализовать вычисление константных выражений в CGModule.cpp