#!/bin/bash

if [ ! -f ./tinylang ]; then
    echo "Не найден ./tinylang"
    exit 1
fi

run_test() {
    local file="$1"
    local desc="$2"
    echo
    echo "──────────────────────────────────────"
    echo "$desc"
    echo "$file"
    if ./tinylang "$file" 2>&1; then
        echo 
    else
        echo 
    fi
}

run_test "WhileIntCondition.mod" "WHILE с INTEGER условием"
run_test "ProcedureReturn.mod" "RETURN 10 в PROCEDURE"
run_test "ScopeTest.mod" "Переменные с одинаковыми именами в разных scope"
run_test "DuplicateParam.mod" "Дублирующие параметры (INTEGER, INTEGER)"
run_test "BooleanLiterals.mod" "Поддержка BOOLEAN и TRUE/FALSE"


# Где регистрируются типы INTEGER, BOOLEAN?
# — В компиляторе они регистрируются статически при инициализации как встроенные (predefined) типы. Обычно в модуле, аналогичном SYSTEM, или в глобальной символической таблице.

# Как семантический анализатор хранит типы?
# — В символических таблицах, привязанных к каждой области видимости (scope). Каждый узел AST содержит информацию о типе выражения, получаемую рекурсивным обходом и проверкой совместимости.

# Как проверяется RETURN в процедуре?
# — При обходе AST семантический анализатор знает, находится ли он внутри PROCEDURE или FUNCTION. Если в PROCEDURE встречается RETURN с выражением — генерируется ошибка.

# Как работает поиск имени в scope?
# — По цепочке областей: сначала в текущей таблице, затем в родительской (scope->parent), пока не найдётся или не дойдёт до глобальной области.

# Где определены диагностические сообщения?
# — В исходном коде компилятора tinylang, скорее всего в файлах семантического анализатора (например, SemanticAnalyzer.cpp или аналогичных).

# Поддерживает ли компилятор TRUE/FALSE?
# — Да, как показано в BooleanLiterals.mod. Это стандартные литералы типа BOOLEAN в Modula-2.