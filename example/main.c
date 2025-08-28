#include <stdio.h>

int main() {
    int n = 25;
    int i;
    long long int first = 0, second = 1, next;

    for (i = 0; i < n; i++) {
        if (i <= 1)
            next = i; // First two terms are 0 and 1
        else {
            next = first + second;
            first = second;
            second = next;
        }
        printf("%d ", (int)next);
    }

    return 0;
}
