void printf(const char *, ...);

int main() {
    int a = 10;
    int b = 20;
    int *p;     // pointer to int
    int *q;

    p = &a;     // p points to a
    q = &b;     // q points to b

    printf("a = %d, b = %d\n", a, b);
    printf("*p = %d, *q = %d\n", *p, *q);

    // Modify values using pointers
    *p = *p + 5;   // a = a + 5
    *q = *q * 2;   // b = b * 2

    printf("After modification:\n");
    printf("a = %d, b = %d\n", a, b);

    // Array and pointer example
    short int arr[5] = {1, 2, 3, 4, 5};
    short int *r = arr;  // pointer to first element

    printf("Array elements using pointer:\n");
    for (int i = 0; i < 5; i++) {
        printf("arr[%d] = %d, *(r+%d) = %d\n", i, arr[i], i, *(r + i));
    }

    return 0;
}
