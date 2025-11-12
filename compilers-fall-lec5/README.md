Lab 5: Arrays and Records in TinyLang → LLVM IR
================================================

Цель: исследовать, как TinyLang обрабатывает массивы и записи (struct), сравнить с C/Clang.

Необходимо:
- собрать компилятор,
- создать тестовые модули на Modula-2 и C,
- сгенерировать LLVM IR,
- ответить на вопросы по реализации и выравниванию.

---

Шаг 1. Сборка проекта TinyLang

# Перейти в директорию с исходниками
cd tinylang

# Создать и зайти в build-директорию
mkdir -p build
cd build

# Настроить сборку (используется системный LLVM)
cmake ..

# Собрать (параллельно)
make -j$(nproc)

# Вернуться в корень лабы
cd ../..

> Успешная сборка даёт исполняемый файл:
>   tinylang/build/tools/driver/tinylang

---

Шаг 2. Проверка работы компилятора

tinylang/build/tools/driver/tinylang --version

Ожидаемый вывод (пример):
  tinylang - Tinylang compiler 0.1
  Default target: x86_64-unknown-linux-gnu
  Host CPU: znver3

Если команда не найдена — проверь путь: бинарник именно в `.../driver/tinylang`.

---

Шаг 3. Тест 1: массив ARRAY [10] OF INTEGER

Создай файл `array10.mod` со следующим содержимым:

MODULE ExampleMod;
TYPE MyArray = ARRAY [10] OF INTEGER;
VAR v: MyArray;
PROCEDURE Main;
BEGIN
  v[2] := 100;
END Main;
END ExampleMod.

> Важно: размер именно `10`, а не `10 + 2`. Иначе будет ошибка (см. Шаг 6).

Скомпилируй и сохрани LLVM IR:

tinylang/build/tools/driver/tinylang array10.mod --emit-llvm > array10.ll

Посмотри результат:

cat array10.ll

Ожидаемое (фрагмент):
  @_t10ExampleMod1v = private global [10 x i64]
  ...
  store i64 100, ptr getelementptr inbounds ([10 x i64], ptr @_t10ExampleMod1v, i32 0, i64 2)

Что происходит:
- `MyArray` → `[10 x i64]` (строка 55 в `tinylang/lib/CodeGen/CGModule.cpp`)
- `v[2] := 100` → `getelementptr inbounds` + `store` (строки 420–440 в `CGProcedure.cpp`)
- Базовых блоков в процедуре Main — 1 (`entry`)

---

Шаг 4. Тест 2: запись RECORD (Cursor)

Создай файл `cursor.mod`:

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

Скомпилируй:

tinylang/build/tools/driver/tinylang cursor.mod --emit-llvm > cursor.ll

Посмотри результат:

cat cursor.ll

Ожидаемое (фрагмент):
  %Cursor = type { i1, i64, i64 }
  @_t5RecEx1c = private global %Cursor
  store i1 true, ptr @_t5RecEx1c, align 1
  store i64 100, ptr getelementptr inbounds (%Cursor, ptr @_t5RecEx1c, i32 0, i32 1), align 8

Что происходит:
- Разбор RECORD — `Parser.cpp`, строки 222–232 (tok::kw_RECORD)
- Генерация типа — `CGModule.cpp`, строки 69–79:
      llvm::StructType::create(Elements, Name, /*isPacked=*/false);
- Поля: `visible` → i1, `x`/`y` → i64
- Индексы в getelementptr: 0 → visible, 1 → x, 2 → y
- Паддинг (выравнивание) НЕ добавляется: структура плотная `{ i1, i64, i64 }`

> Почему нет паддинга? 
> TinyLang создаёт non-packed struct (isPacked = false), но для глобальных переменных LLVM не вставляет явные байты выравнивания, если не требуется ABI-совместимость.

---

Шаг 5. Тест 3: C-структура и Clang

Создай временный файл с C-структурой:

echo '
#include <stdint.h>
struct C {
  uint8_t visible;
  uint64_t x, y;
};
int main() { struct C c; c.visible = 1; c.x = 2; return 0; }
' > cstruct.c

Сгенерируй LLVM IR:

clang -S -emit-llvm -o - cstruct.c | grep -A5 '%struct\.C'

Ожидаемый вывод:
  %struct.C = type { i8, i64, i64 }

Также посмотри весь IR (ищем alloca):

clang -S -emit-llvm -o - cstruct.c | grep -A2 'alloca %struct\.C'

Вывод (пример):
  %1 = alloca %struct.C, align 8

Что происходит:
- Структура в IR — `{ i8, i64, i64 }` (без явного паддинга)
- Но переменная в стеке выровнена по 8 байтам: `align 8`
- Доступ к полям — через `getelementptr ... , align X`, где X зависит от поля:
      visible — align 1 (i8 не требует выравнивания)
      x, y   — align 8 (i64 требует 8-байтного выравнивания)

> Почему Clang не добавил [7 x i8]?
> - ABI x86-64 разрешает не выровненный доступ (медленнее, но допустим).
> - LLVM полагается на выравнивание памяти (`align 8`) и инструкций (offset + align), а не на изменение layout структуры.
> - Если бы структура передавалась между модулями (библиотеками), или использовалась `#pragma pack(push,1)`, паддинг мог бы появиться.

---

Шаг 6. Тест 4: выражение в размере массива ([10 + 4])

Создай файл `array_expr.mod`:

MODULE Test;
TYPE MyArray = ARRAY [10 + 4] OF INTEGER;
VAR v: MyArray;
PROCEDURE P; BEGIN END P;
END Test.

Попробуй скомпилировать:

tinylang/build/tools/driver/tinylang array_expr.mod --emit-llvm

→ Ошибка: assertion failed в CGModule.cpp, строка ~61:
    assert(llvm::cast<IntegerLiteral>(Nums) && "Expected an integer literal");

Причина:
- Parser.cpp (строки 213–221): `parseExpression(E)` — позволяет любое выражение.
- Sema.cpp (строки 137–153): проверяет `E->isConst() && E->getType() == INTEGER` — пропускает `10 + 4`.
- CGModule.cpp (строка 60): есть TODO: "// TODO Evaluate the constant expression."
  → Сейчас ожидается только `IntegerLiteral`, но не `InfixExpression`.

Вывод:
- Парсер и семантика **допускают** выражения вида `10 + 4`.
- Генератор кода **НЕ поддерживает** их → аварийное завершение.
- Чтобы заработало — нужно реализовать вычисление константных выражений в `CGModule::convertType`.

---

Итоговые ответы по заданию:

2. Массив:
   - Разбор: `Parser.cpp`, строки 213–221 (tok::kw_ARRAY)
   - Генерация: `CGModule.cpp`, строки 52–68
   - Базовых блоков в Main: 1 (`entry`)

3. RECORD:
   - Разбор: `Parser.cpp`, строки 222–232 (tok::kw_RECORD)
   - Генерация: `CGModule.cpp`, строки 69–79
   - Паддинг после `visible`? — **НЕТ** (`{ i1, i64, i64 }`)

4. C-структура в Clang:
   - Паддинг в IR? — **НЕТ** (`{ i8, i64, i64 }`)
   - Но переменная выровнена: `alloca ..., align 8`
   - Причина: x86-64 допускает не выровненный доступ, LLVM использует `align` вместо изменения layout.

5. `[10 + 4]`:
   - Допускается? — **НО**, но только на уровне парсера и семантики.
   - Генерация кода падает → **фактически НЕ поддерживается**.

Готово.