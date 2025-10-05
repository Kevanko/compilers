int expr(int a, int b)
{
    int res = 0;
    int i = a;
    while (i < b) {
        res = res + i;
        i++;
    }
    return res;
}
