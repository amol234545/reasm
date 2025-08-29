#include <stdio.h>

// Function to calculate factorial
unsigned long factorial(int n) {
    if (n <= 1) return 1;
    unsigned long result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

int main() {
    int numbers[] = {3, 5, 7, 10};
    int size = sizeof(numbers) / sizeof(numbers[0]);

    // Print factorials of the numbers in the array
    for (int i = 0; i < size; i++) {
        printf("Factorial of %d is %d", numbers[i], (int)factorial(numbers[i]));
    }

    return 0;
}
