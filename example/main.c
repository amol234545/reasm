#include <stdio.h>
int is_prime(int num) {
    if (num < 2) return 0;
    for (int i = 2; i * i <= num; i++) {
        if (num % i == 0) return 0;
    }
    return 1;
}

int main() {
    int N = 100;

    for (int i = 1; i <= N; i++) {
        //printf("%d", i); <- Todo check why this fails.
        if (is_prime(i)) {
            printf("%d", i);
        }
    }
    return 0;
}
