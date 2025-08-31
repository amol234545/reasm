int printf(const char *, ...);

int main() {
    int n, i;
    n=10;
    long long first = 0, second = 1, next;

    printf("Fibonacci Sequence: ");

    for (i = 0; i < n; i++) {
        if (i <= 1)
            next = i;
        else {
            next = first + second;
            first = second;
            second = next;
        }
        printf("%d ", (int)next);
    }

    printf("\n");
    return 0;
}
