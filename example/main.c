void print(const char *str);

int main() {
    int i, j;
    int rows = 5;
    char output[1024];
    int pos = 0;

    for (i = 1; i <= rows; i++) {
        for (j = 1; j <= i; j++) {
            output[pos++] = '0' + j;
        }
        output[pos++] = '\n';
    }

    output[pos] = '\0';

    print(output);

    return 0;
}
