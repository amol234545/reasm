package compiler

import (
	"debug/elf"
	"fmt"

	log "github.com/sirupsen/logrus"
	"golang.org/x/arch/riscv64/riscv64asm"
)

func ParseFromElf(f *elf.File) []AssemblyCommand {
	/* validate file */
	if f.Class != elf.ELFCLASS64 {
		log.Error("ELF file is not 32-bit.")
		return []AssemblyCommand{}
	} else if f.Machine != elf.EM_RISCV {
		log.Error("ELF file is not RISC-V.")
		return []AssemblyCommand{}
	} else if f.Data != elf.ELFDATA2LSB {
		log.Error("ELF file is not little-endian.")
		return []AssemblyCommand{}
	} else if f.Type != elf.ET_EXEC {
		log.Error("ELF file is not an executable.")
		return []AssemblyCommand{}
	}

	/* look for bytecode */
	text := f.Section(".text")
	if text == nil {
		log.Error(".text section not found")
		return []AssemblyCommand{}
	}

	code, err := text.Data()
	if err != nil {
		log.Error(err)
		return []AssemblyCommand{}
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
