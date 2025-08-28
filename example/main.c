void print(const char *str);

void printtwice(const char *str) {
    print(str);
    print(str);
}

int main() {
    printtwice("hi");

    return 0;
}
