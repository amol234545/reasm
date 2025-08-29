void print(const char *str);

void printtwice(const char *str) {
    for (int i = 0; i < 2; i++) {
        print(str);
    }
}

int main() {
    printtwice("hi");

    return 0;
}
