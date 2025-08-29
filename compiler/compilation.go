package compiler

import (
	_ "embed"
	"strings"
)

//go:embed boilerplate.luau
var luau_boilerplate string

var instructions = map[string]func(*OutputWriter, AssemblyCommand){
	"ret":   ret,
	"sw":    sw,
	"li":    li,
	"lw":    lw,
	"sh":    sh,
	"lui":   lui,
	"call":  call,
	"slli":  slli,
	"srli":  srli,
	"add":   add,
	"addi":  add,
	"sub":   sub,
	"subi":  sub,
	"j":     jump,
	"blt":   blt,
	"bltu":  blt,
	"bnez":  bnez,
	"and":   and,
	"andi":  and,
	"slt":   slt,
	"sltu":  slt,
	"sltiu": slt,
	"srai":  srai,
	"bge":   bge,
	"beq":   beq,
	"bgeu":  bge,
	"div":   div,
	"mul":   mul,
	"mulh":  mulh,
	"sb":    sb,
	"mv":    move,
	"lb":    lb,
	"lbu":   lbu,
	"beqz":  beqz,
	"bgez":  bgez,
	"bne":   bne,
	"rem":   rem,
	"remu":  rem,
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
