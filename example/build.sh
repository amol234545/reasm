SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLANG_DIR="/opt/homebrew/opt/llvm/bin/clang"
CLANG_OPT=""
$CLANG_DIR -S -target riscv32 ${CLANG_OPT} -march=rv32im "$SCRIPT_DIR/main.c" -o "$SCRIPT_DIR/main.s"
