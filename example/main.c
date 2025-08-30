void printf(const char *, ...);

int factorial(int n) {
    if (n <= 0) {
        return 1; // base case
    }

    int result = n * factorial(n - 1);
    if (result % 2 == 0) {
        printf("%d! = %d (even)", n, result);
    } else {
        printf("%d! = %d (odd)", n, result);
    }
    return result;
}

int main() {
    int numbers[] = {3, 4, -5, 0, 6};
    int size = sizeof(numbers) / sizeof(numbers[0]);

    for (int i = 0; i < size; i++) {
        printf("Computing factorial(%d)", numbers[i]);
        factorial(numbers[i]);
        printf("---------");
    }

    return 0;
}
