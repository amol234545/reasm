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
	"lui": lui,
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

	/* F extension */
	"fadd.s": fadd_s,

	/** Memory */
	"flw": flw,
	"fsd": fsd,

	/** Conversion */
	"fmv.w.x":  fmv_w_x,
	"fcvt.d.s": fcvt_d_s,

	/* Abstraction */
	"auipc": auipc,
	"ret":   ret,
	"call":  call,
	"mv":    move,
}
var directives = map[string]func(*OutputWriter, []string){
	".asciz":  asciz,
	".string": asciz,
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
		if command.Type == Label {
			writer.CurrentLabel = command.Name /* macros depend on label */
		}
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
	writer.CurrentLabel = ""
	WriteIndentedString(writer, "PC = %d\n", FindLabelAddress(writer, writer.MainSymbol))
	WriteIndentedString(writer, "registers.x2 = (buffer.len(memory) + %d) / 2 -- start at the center after static data\n", writer.MemoryDevelopmentPointer)
	WriteIndentedString(writer, "if registers.x2 >= buffer.len(memory) then error(\"Not enough memory\") end\n")
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
		int_to_float = int_to_float,
		float_to_int = float_to_int,
		hi = hi,
		lo = lo,
		float_to_double = float_to_double,
		double_to_float = double_to_float,
		two_words_to_double = two_words_to_double,
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
	registers := generateRegistryMap(baseRegs)
	return []byte(strings.Replace(strings.Replace(luau_boilerplate, "--{registers here}", registers, 1), "--{code here}", code, 1))
}
