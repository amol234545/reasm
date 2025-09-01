# ASM-Decomp (no name yet)
> A full **RISC-V IM** compatible assembler/disassembler to **Luau**.
## TODO:
- Floating point & Double support
- Work on support for ELF files.
* `No bindings for function '<register??>'`
* ECALL & AUIPC
* Read labels
- Handle overflows correctly.
- Vector operations
## Example:
```c
void printf(const char *, ...); /* manually define printf if we are not using stdlib.h */

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
clang -S -target riscv32 -march=rv32im main.c -o main.s
asmdecomp main.s -o main.luau # where the magic happens
luau main.luau
```

## Usage:
```bash
asmdecomp main.S -o main.luau --mode {module|main|bench} --trace --comments
```

Input file can either be a `.S` assembly file, or a `.elf` file which is linked.

Assembly files use `call` to invoke functions which are provided with
```lua
module.functions["sprintf"] = function() end
```
while linked files (like ELF) will use system calls that can be intercepted by
```lua
module.system[67] = function() end
```

**TLDR:**
- Use assembly files if you are compiling from code that is intended to become Luau.
- Use elf files if you are compiling to port code to Luau.

### Options
- `--comments`: This will place comments all around the generated code with details such as the instruction's purpose, operands, and any relevant debug information.
- `--trace`: Everytime a jump happens it will log to output, this is a more extreme option and should only be used for debug.
- `--mode`:
  * `module` will automatically expose memory, API to inject functions, and registers to whoever imports.
  * `main` will generate a simple Luau file which runs on its own.
  * `bench` will generate a module prepared for benchmarking with [Scriptbench](https://devforum.roblox.com/t/scriptbench-free-opensource-heavy-duty-benchmarker/3815286) or [Benchmarker](https://devforum.roblox.com/t/benchmarker-plugin-compare-function-speeds-with-graphs-percentiles-and-more/829912).
