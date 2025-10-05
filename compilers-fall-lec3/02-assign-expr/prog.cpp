int expr1(int a, int b)
{
    int c = a + b;
    return c;
}

int expr2(int a, int b)
{
    int c = a + 1 + b + 2;
    return c;
}

int expr3(int a, int b)
{
    int c = a + 4 * b;
    return c;
}

int expr4(int a, int b)
{
    int c = a + b * (1 + 4);
    return c;
}

int expr5(int a, int b)
{
    int c = -a + 4 / b;
    return c;
}
