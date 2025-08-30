void printf(const char *, ...);

int fib(int n) {
    if (n <= 1)
        return n;
    return fib(n-1) + fib(n-2);
}

void printFib(int n, int i) {
    if (i < n) {
        printf("%d ", fib(i));
        printFib(n, i+1); // recursive printing
    }
}

int main() {
    int terms = 10; // number of Fibonacci numbers to print
    printFib(terms, 0);
    return 0;
}
