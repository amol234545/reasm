package compiler

import (
	_ "embed"
	"fmt"
	"sort"
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

	/* Abstraction */
	"auipc": auipc,
	"ret":   ret,
	"call":  call,
	"mv":    move,

	/* Floating extension (UNFINISHED!) */
	"fclass.s": fclass,

	"feq.s":  feq,
	"flt.s":  flt,
	"flte.s": flte,

	/** move */
	"fmv.x.w":  move,
	"fmv.w.x":  move,
	"fcvt.d.s": move,
	"fcvt.s.d": move,
	"fmv.s":    move,

	/** basic math */
	"fadd.s": add,
	"fsub.s": sub,
	"fmul.s": mul,
	"fdiv.s": fdiv,

	/** load & store */
	"flw": flw,
	"fsw": fsw,
	"fld": fld,
	"fsd": fsd,

	/** special */
	"fsqrt.s":  fsqrt,
	"fsgnj.s":  fsgnj,
	"fsgnjn.s": fsgnjn,
	"fsgnjx.s": fsgnjx,

	"fmin.s": fmin,
	"fmax.s": fmax,

	/** convert */
	"fcvt.w.s":  fcvtint,
	"fcvt.wu.s": fcvtint,
	"fcvt.s.w":  fcvt,
	"fcvt.s.wu": fcvt,

	/** fused */
	"fmadd.s":  fmadd,
	"fmsub.s":  fmsub,
	"fnmadd.s": fnmadd,
	"fnmsub.s": fnmsub,
}
var attributes = map[string]func(*OutputWriter, []string){
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
			WriteIndentedString(writer, "-- unknown instruction: %s (%v)\n", command.Name, command.Arguments)
		}
	case Attribute:
		attributeComponents := ReadAttribute(command.Name)
		attributeName := attributeComponents[0]
		if _, ok := attributes[attributeName]; ok {
			attributes[attributeName](writer, attributeComponents)
		} else if writer.DebugComments {
			WriteIndentedString(writer, "-- ASM ATTRIBUTE: %s\n", command.Name)
		}
	case Label:
		label(writer, command)
	}
}
func BeforeCompilation(writer *OutputWriter) {
	WriteIndentedString(writer, "while PC ~= 0 do\n")
	writer.Depth++
}
func AfterCompilation(writer *OutputWriter) []byte {
	AddEnd(writer) // end the current label, if active

	// load the label names
	WriteIndentedString(writer, "if init then -- load label names for quick access\n")
	writer.Depth++
	WriteIndentedString(writer, "labels = {\n")
	writer.Depth++
	for index, label := range writer.Labels {
		WriteIndentedString(writer, "[\"%s\"] = %d,\n", label, index+1)
	}
	writer.Depth--
	WriteIndentedString(writer, "}\n")
	WriteIndentedString(writer, "PC = labels[\"main\"]\n")
	writer.Depth--
	WriteIndentedString(writer, "end\n")

	WriteIndentedString(writer, "init = false -- do not initialize again\n")

	// check if invalid PC, then break
	if writer.DebugComments {
		WriteIndentedString(writer, "-- if no PC, or invalid PC then break (look into alternative implementations in the future) \n")
	}
	WriteIndentedString(writer, "if (not PC) or PC == 0 or PC > %d then\n", writer.MaxPC-1)
	writer.Depth++
	WriteIndentedString(writer, "break\n")
	writer.Depth--
	WriteIndentedString(writer, "end\n")

	// end the while loop we initialized in StartLuau
	writer.Depth--
	WriteIndentedString(writer, "end")

	code := string(writer.Buffer)
	registers := generateRegistryMap(regs)
	return []byte(strings.Replace(strings.Replace(luau_boilerplate, "--{registers here}", registers, 1), "--{code here}", code, 1))
}
