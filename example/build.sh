SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLANG_DIR="/opt/homebrew/opt/llvm/bin/clang"
CLANG_OPT="-I/opt/homebrew/Cellar/riscv-gnu-toolchain/main/riscv64-unknown-elf/include"
$CLANG_DIR -S -target riscv32 ${CLANG_OPT} "$SCRIPT_DIR/main.c" -o "$SCRIPT_DIR/main.s"
