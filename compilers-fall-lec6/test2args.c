#include <stdio.h>

int add(int a, int b) {      // ← 2 аргумента — будет проинструментировано
    return a + b;
}

int single(int x) {          // ← 1 аргумент — НЕ будет
    return x;
}

int main() {
    printf("Result: %d\n", add(3, 4));
    single(5);
    return 0;
}
