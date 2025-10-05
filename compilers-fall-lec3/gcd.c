#include <stdio.h>

int gcd(int a, int b)
{
    while (b != 0) {
        int t = a % b;
        a = b;
        b = t;
    }
    return a;
}

int main()
{
    printf("gcd(12, 15) = %d\n", gcd(12, 15));
    return 0;
}


