void printf(const char *, ...);

int fibonacci(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

int main() {
    int n = 12;  // hardcoded value
    int fib_sequence[n];

    // Fill array with Fibonacci numbers
    for (int i = 0; i < n; i++) {
        fib_sequence[i] = fibonacci(i);
    }

    // Print the sequence
    //printf("Fibonacci sequence up to %d terms: ", n);
    for (int i = 0; i < n; i++) {
        //printf("%d ", fib_sequence[i]);
    }

    return 0;
}
