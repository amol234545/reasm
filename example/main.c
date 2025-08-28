#include <stdio.h>

int main() {
    for (int i = 0; i <= 25; i++) {
        printf("%d", i);
        if (i%2 == 0){
            printf("DIVISIBLE BY 2: %d", i);
        }
    }
    return 0;
}
