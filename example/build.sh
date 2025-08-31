SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLANG_DIR="/opt/homebrew/opt/llvm/bin/clang"
CLANG_OPT="-I/opt/homebrew/Cellar/riscv-gnu-toolchain/main/riscv64-unknown-elf/include"
$CLANG_DIR -S -march=rv32im -target riscv32-unknown-elf ${CLANG_OPT} "$SCRIPT_DIR/main.c" -o "$SCRIPT_DIR/main.s"

go run main.go $SCRIPT_DIR/main.s -o $SCRIPT_DIR/main.luau --comments --mode main
