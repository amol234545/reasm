package compiler

import (
	"debug/elf"
	"fmt"

	"golang.org/x/arch/riscv64/riscv64asm"
)

func ParseFromElf(f *elf.File) []AssemblyCommand {
	/* validate file */
	if f.Class != elf.ELFCLASS32 {
		panic("ELF file is not 32-bit.")
	} else if f.Machine != elf.EM_RISCV {
		panic("ELF file is not RISC-V.")
	} else if f.Data != elf.ELFDATA2LSB {
		panic("ELF file is not little-endian.")
	} else if f.Type != elf.ET_EXEC {
		panic("ELF file is not an executable.")
	}

	/* look for bytecode */
	text := f.Section(".text")
	if text == nil {
		panic(".text section not found")
	}

	code, err := text.Data()
	if err != nil {
		panic(err)
	}

	/* TODO: parse the actual data of the file  */
	for i := 0; i < len(code); i += 4 { // RISC-V instructions are 4 bytes
		inst, err := riscv64asm.Decode(code[i : i+4])
		if err != nil {
			fmt.Println("Decode error:", err)
			continue
		}
		fmt.Printf("%#x: %s\n", i, inst)
	}

	return []AssemblyCommand{}
}
