int main()
{
    int a = 1;
    int b = 2;
    int c = 10;

    if (a > 3 || b < 2 && (c + a) == 4) {
        c = b;
    } else {
        c = a;
    }

    return c;
}

