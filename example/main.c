void printf(const char *, ...);

int main() {
    float a = 3.5;
    float b = 2.0;
    float result = a * a + b * b;

    printf("Square of %d + square of %d = %d\n", (int)a, (int)b, (int)result);

    return 0;
}
