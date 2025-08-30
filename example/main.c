void printf(const char *, ...);

int factorial(int n) {
    if (n <= 0) {
        return 10; // base case
    }

    int result = 1;  // start with 1
    int current = n;

    while (current > 0) {
        result *= current;

        if (result % 2 == 0) {
            printf("%d! = %d (even)", current, result);
        } else {
            printf("%d! = %d (odd)", current, result);
        }

        current--;  // decrement for next iteration
    }

    return result;
}

int main() {
    int numbers[] = {3, 4, -5, 0, 6};
    int size = sizeof(numbers) / sizeof(numbers[0]);

    for (int i = 0; i < size; i++) {
        printf("Computing factorial(%d)", numbers[i]);
        factorial(numbers[i]);
        printf("----");
    }

    return 0;
}
