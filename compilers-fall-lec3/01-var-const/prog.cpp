// C++ constants
const int A = 10;
const int B = 20;
const int maxBufSize = 1 << 20;
const double speedLimit = 3e8;
const char *progName = "ibex";

// Variables (initialized)
int numUsers = 0;
bool isLoaded = false;
long long int limit;

// Variables (non initialized)
int buf[maxBufSize];

int sum(int a, int b)
{
    return a + b;
}

int main()
{
    int b = 100;
    return sum(A, b);
}
