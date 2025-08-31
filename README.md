# ASM-Decomp (no name yet)
> [!NOTE]
> Heavy optimizations (like `-O2`) will not work, it tends to use MIPS instructions rather than RISCV which are not supported.

## TODO:
- Floating point & Double support
- Work on support with a linker, need to figure out system calls & defining calls that ASM will presume exist (ex: `printf`).
- Add all pseudo-instructions.
- Handle overflows correctly.
- Float storage.
## Example:
```c
void printf(const char *, ...); /* manually define printf if we are not using stdlib.h which does often include unsupported functions */

int fib(int n) {
    if (n <= 1)
        return n;
    return fib(n-1) + fib(n-2);
}

void printFib(int n, int i) {
    if (i < n) {
        printf("%d ", fib(i));
        printFib(n, i+1);
    }
}

int main() {
    int terms = 10;
    printFib(terms, 0);
    return 0;
}
```
```bash
clang -S -Oz -target riscv32 -march=rv32im main.c -o main.s
asmdecomp main.s -o main.luau # where the magic happens
luau main.luau
```

## Options
- `--comments`: This will place comments all around the generated code with details such as the instruction's purpose, operands, and any relevant debug information.
- `--trace`: Everytime a jump happens it will log to output, this is a more extreme option and should only be used for debug.
