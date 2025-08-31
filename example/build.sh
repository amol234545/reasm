SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLANG_OPT=""


riscv64-unknown-elf-gcc -O2 -march=rv32im -mabi=ilp32 "$SCRIPT_DIR/main.c" -o "$SCRIPT_DIR/main.elf"

# Assembly → Luau
go run main.go $SCRIPT_DIR/main.s \
  -o $SCRIPT_DIR/main.luau \
  --comments --mode main
