int expr1(int a, int b)
{
    int res = b;
    if (a < b)
        res = a;
    return res;
}

int expr2(int a, int b)
{
    int res;
    if (a < b)
        res = a;
    else
        res = b;
    return res;
}

int expr3(int a, int b)
{
    if (a < b)
        return a;
    else
        return b;
}

int expr4(int a, int b)
{
    int res = b;
    if (a < b) {
        if (a > 10)
            res = a;
        else 
            res = 10;
    } else {
        res = b;
    }
    return res;
}
