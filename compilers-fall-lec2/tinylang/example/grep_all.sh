#!/bin/bash

ROOT_DIR="$(cd .. && pwd)"

if [ ! -d "$ROOT_DIR/lib" ]; then
    echo "❌ Не найден lib/"
    exit 1
fi

echo "🔍 Глубокий поиск в исходниках tinylang..."
echo "📁 Корень: $ROOT_DIR"
echo

# 1. Проверка условия WHILE/IF
echo "=== Проверка условия WHILE/IF (должно быть BOOLEAN) ==="
grep -r -n -A2 -B2 "must have type BOOLEAN\|IF statement\|condition.*BOOLEAN" "$ROOT_DIR/lib/Sema/" --include="*.cpp"
echo

# 2. RETURN в PROCEDURE
echo "=== RETURN в PROCEDURE ==="
grep -r -n -A2 -B2 "Procedure does not allow RETURN\|RETURN.*value.*procedure" "$ROOT_DIR/lib/Sema/" --include="*.cpp"
echo

# 3. Дублирование имён
echo "=== Дублирование имён ==="
grep -r -n -A2 -B2 "already declared\|symbol.*already\|redefinition" "$ROOT_DIR/lib/Sema/" --include="*.cpp"
echo

# 4. Диагностические сообщения (error + ключевые слова)
echo "=== Диагностические сообщения ==="
grep -r -n "error.*:" "$ROOT_DIR/lib/Sema/" --include="*.cpp" | grep -E "(RETURN|BOOLEAN|symbol|IF|WHILE|PROCEDURE)"
echo

# 5. Где инициализируются IntegerType/BooleanType?
echo "=== Инициализация встроенных типов ==="
grep -r -n -A3 -B1 "IntegerType\|BooleanType" "$ROOT_DIR/lib/Sema/" --include="*.cpp"
echo

# 6. Где создаются TRUE/FALSE?
echo "=== Создание TRUE/FALSE литералов ==="
grep -r -n "TrueLiteral\|FalseLiteral" "$ROOT_DIR/lib/Sema/" --include="*.cpp"
echo

echo "✅ Глубокий поиск завершён."