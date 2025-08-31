package compiler

import (
	"debug/elf"
	"fmt"

	"golang.org/x/arch/riscv64/riscv64asm"
)

func ParseFromElf(f *elf.File) []AssemblyCommand {
	if f.Class != elf.ELFCLASS32 {
		panic("ELF file is not 32-bit.")
	} else if f.Machine != elf.EM_RISCV {
		panic("ELF file is not RISC-V.")
	} else if f.Data != elf.ELFDATA2LSB {
		panic("ELF file is not little-endian.")
	} else if f.Type != elf.ET_EXEC {
		panic("ELF file is not an executable.")
	}

	/* TODO: parse the actual data of the file  */
	code := []byte{
		0x93, 0x00, 0x10, 0x00, // addi x1, x0, 1
		0x13, 0x01, 0x20, 0x00, // addi x2, x0, 2
	}
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
