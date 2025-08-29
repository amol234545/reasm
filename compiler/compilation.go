package compiler

import (
	_ "embed"
	"strings"
)

//go:embed boilerplate.luau
var luau_boilerplate string

var instructions = map[string]func(*OutputWriter, AssemblyCommand){
	/* bit shifts */
	"sll":  sll,
	"srl":  srl,
	"slli": sll,
	"srli": srl,
	"sra":  sra,
	"srai": sra,

	/* bit operations */
	"and": and,
	"xor": xor,
	"or":  or,

	"andi": and,
	"xori": xor,
	"ori":  or,

	/* memory */
	/** save */
	"sb": sb,
	"sh": sh,
	"sw": sw,

	/** load */
	"lb": lb,
	"lh": lh,
	"lw": lw,

	/*** immediates */
	"li":  li,
	"lui": li,

	/*** unsigned */
	"lbu": lbu,
	"lhu": lhu,

	/* math */
	"add":  add,
	"addi": add,
	"sub":  sub,
	"subi": sub,

	/** M extension */
	"div": div,
	"mul": mul,
	"rem": rem,

	/*** descendants */
	"remu":  rem,
	"mulh":  mulh,
	"mulsu": mulh,
	"mulu":  mulh,
	"divu":  div,

	/* branching */
	"bne":  bne,
	"blt":  blt,
	"bltu": blt,
	"bge":  bge,
	"beq":  beq,
	"bgeu": bge,

	/** zero descendants */
	"bnez": bnez,
	"beqz": beqz,
	"bgez": bgez,

	/* jump */
	"j":    jump,
	"jalr": jalr,
	"jal":  jal,

	/* os */
	"ecall":  ecall,
	"ebreak": ebreak,
	"fence":  fence,

	/* set less/greator then */
	"slt":   slt,
	"sltu":  slt,
	"sltiu": slt,
	"slti":  slt,

	/* abstraction */
	"auipc": auipc,
	"ret":   ret,
	"call":  call,
	"mv":    move,
}
var attributes = map[string]func(*OutputWriter, []string){
	".asciz": asciz,
	".size":  size,
}

/* main */
func CompileInstruction(writer *OutputWriter, command AssemblyCommand) {
	switch command.Type {
	case Instruction:
		if command.Name == "" {
			break
		}

		if cmdFunc, ok := instructions[command.Name]; ok {
			WriteIndentedString(writer, "-- %s (%v)\n", command.Name, command.Arguments)

			cmdFunc(writer, command)
		} else {
			WriteIndentedString(writer, "-- unknown instruction: %s (%v)\n", command.Name, command.Arguments)
		}
	case Attribute:
		attributeComponents := ReadAttribute(command.Name)
		attributeName := attributeComponents[0]
		if _, ok := attributes[attributeName]; ok {
			attributes[attributeName](writer, attributeComponents)
		} else {
			WriteIndentedString(writer, "-- ASM ATTRIBUTE: %s\n", command.Name)
		}
	case Label:
		label(writer, command)
	}
}
func BeforeCompilation(writer *OutputWriter) {
	WriteIndentedString(writer, "while PC do\n")
	writer.Depth++
}
func AfterCompilation(writer *OutputWriter) []byte {
	AddEnd(writer) // end the current label, if active

	WriteIndentedString(writer, "init = false -- do not initialize again\n")

	// check if invalid PC, then break
	WriteIndentedString(writer, "-- if no PC, or invalid PC then break (look into alternative implementations in the future) \n")
	WriteIndentedString(writer, "if (not PC) or (")
	for ind, label := range writer.Labels {
		if ind > 0 {
			WriteString(writer, " and ")
		}
		WriteString(writer, "PC ~= \"%s\"", label)
	}
	WriteString(writer, ") then\n")
	writer.Depth++
	WriteIndentedString(writer, "break\n")
	writer.Depth--
	WriteIndentedString(writer, "end\n")

	// end the while loop we initialized in StartLuau
	writer.Depth--
	WriteIndentedString(writer, "end")

	return []byte(strings.Replace(luau_boilerplate, "--{code here}", string(writer.Buffer), 1))
}
