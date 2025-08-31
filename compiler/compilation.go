package compiler

import (
	_ "embed"
	"fmt"
	"sort"
	"strings"

	log "github.com/sirupsen/logrus"
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
	"not": not,

	/** immediate */
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

	/*** variants */
	"li":  li,
	"lui": li,
	"lbu": lbu,
	"lhu": lhu,

	/* math */
	"add":  add,
	"addi": add,
	"sub":  sub,
	"subi": sub,
	"neg":  neg,

	/* M extension */
	"div": div,
	"mul": mul,
	"rem": rem,

	/*** descendants */
	"remu":  rem,
	"mulh":  mulh,
	"mulhu": mulh,
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
	"bgt":  bgt,
	"bgtu": bgt,
	"ble":  ble,
	"bleu": ble,

	/** zero descendants */
	"bnez": bnez,
	"beqz": beqz,
	"bltz": bltz,
	"bgtz": bgtz,
	"blez": blez,
	"bgez": bgez,

	/* jump */
	"j":    jump,
	"jalr": jalr,
	"jr":   jr,
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
	"seqz":  seqz,
	"snez":  snez,
	"sgtz":  sgtz,
	"sltz":  sltz,

	/* Abstraction */
	"auipc": auipc,
	"ret":   ret,
	"call":  call,
	"mv":    move,
}
var directives = map[string]func(*OutputWriter, []string){
	".asciz":  asciz,
	".string": asciz,
	".size":   size,
	".word":   word,
	".byte":   byte_,
	".half":   half,
}

func generateRegistryMap(m map[string]bool) string {
	var sb strings.Builder

	// Sort keys for consistent output
	keys := make([]string, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	for _, k := range keys {
		// All values are zero
		sb.WriteString(fmt.Sprintf("    [\"%s\"] = 0,\n", k))
	}

	return sb.String()
}

/* main */
func CompileInstruction(writer *OutputWriter, command AssemblyCommand) {
	switch command.Type {
	case Instruction:
		if command.Name == "" {
			break
		}

		if cmdFunc, ok := instructions[command.Name]; ok {
			if writer.DebugComments {
				WriteIndentedString(writer, "-- %s (%v)\n", command.Name, command.Arguments)
			}

			cmdFunc(writer, command)
		} else {
			log.Warn("unknown instruction: " + command.Name)
		}
	case Label:
		label(writer, command)
	}
}
func BeforeCompilation(writer *OutputWriter) {

	/* load directives */
	WriteIndentedString(writer, "function init()\n")
	writer.Depth++
	for _, command := range writer.Commands {
		if command.Type != Directive {
			continue
		}

		attributeComponents := ReadDirective(command.Name)
		attributeName := attributeComponents[0]
		if _, ok := directives[attributeName]; ok {
			directives[attributeName](writer, attributeComponents)
		} else if writer.DebugComments {
			WriteIndentedString(writer, "-- ASM DIRECTIVE: %s\n", command.Name)
		}
	}
	WriteIndentedString(writer, "PC = %d\n", FindLabelAddress(writer, writer.MainSymbol))
	writer.Depth--
	WriteIndentedString(writer, "end\n")

	/* start code */
	WriteIndentedString(writer, "function main()\n")
	writer.Depth++
	WriteIndentedString(writer, "while PC ~= 0 do\n")
	writer.Depth++
}
func AfterCompilation(writer *OutputWriter) []byte {
	AddEnd(writer) // end the current label, if active

	// check if invalid PC, then break
	WriteIndentedString(writer, "if (not PC) or PC == 0 or PC > %d then\n", writer.MaxPC-1)
	writer.Depth++
	WriteIndentedString(writer, "break\n")
	writer.Depth--
	WriteIndentedString(writer, "end\n")

	// end the while loop we initialized in StartLuau
	writer.Depth--
	WriteIndentedString(writer, "end\n")
	writer.Depth--
	WriteIndentedString(writer, "end\n")

	// final code based on mode
	if writer.Mode == "main" {
		WriteString(writer, "init()\nmain()\n")
	} else if writer.Mode == "module" {
		WriteString(writer, `return setmetatable({
	init = init,
	main = main,
	memory = memory,
	functions = functions,
	util = {
		extract_args = extract_args,
		read_string = read_string,
		format_string = format_string,
	},
	PC = PC,
	registers = registers,
	data = data
}, {__call = function() init(); main() end})`)
	} else if writer.Mode == "bench" {
		WriteString(writer, `
return {
    Name = "RISCV File",

    BeforeEach = init,

    Functions = {
        ["main"] = main,
    }
}`)
	}

	code := string(writer.Buffer)
	registers := generateRegistryMap(regs)
	return []byte(strings.Replace(strings.Replace(luau_boilerplate, "--{registers here}", registers, 1), "--{code here}", code, 1))
}
