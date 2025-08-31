void printf(const char *, ...);


int main() {
    printf("Square table:");
    for (int i = 1; i <= 16; i++) {
        printf("%d: %d", i, i*i);
    }

    return 0;
}
