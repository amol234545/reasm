package compiler

import (
	_ "embed"
	"fmt"
	"sort"
	"strconv"
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
	"fclass.s": fclass,
	"fclass.d": fclass,

	/** Arithmetic */
	"fadd.s": add,
	"fsub.s": sub,
	"fdiv.s": div,
	"fmul.s": mul,
	"fadd.d": add,
	"fsub.d": sub,
	"fdiv.d": div,
	"fmul.d": mul,
	"fneg.s": fneg,
	"fneg.d": fneg,

	/** More advanced */
	"fabs.s":  fneg,
	"fabs.d":  fabs,
	"fsqrt.s": fsqrt,
	"fmin.s":  fmin,
	"fmax.s":  fmax,
	"fsqrt.d": fsqrt,
	"fmin.d":  fmin,
	"fmax.d":  fmax,

	/** Memory */
	"flw": flw,
	"fsw": fsw,
	"fld": fld,
	"fsd": fsd,

	/** Sign */
	"fsgnj.s":  fsgnj,
	"fsgnjn.s": fsgnjn,
	"fsgnjx.s": fsgnjx,
	"fsgnj.d":  fsgnj,
	"fsgnjn.d": fsgnjn,
	"fsgnjx.d": fsgnjx,

	/** Comparators */
	"feq.s": feq,
	"flt.s": flt,
	"fle.s": fle,
	"feq.d": feq,
	"flt.d": flt,
	"fle.d": fle,

	/** Fused */
	"fmadd.s":  fmadd,
	"fmsub.s":  fmsub,
	"fnmadd.s": fnmadd,
	"fnmsub.s": fnmsub,

	"fmadd.d":  fmadd,
	"fmsub.d":  fmsub,
	"fnmadd.d": fnmadd,
	"fnmsub.d": fnmsub,

	/** Conversion */
	"fmv.d": move,

	"fmv.w.x":   fmv_w_x,
	"fmv.x.w":   fmv_x_w,
	"fcvt.w.s":  fcvt_w_s,
	"fcvt.wu.s": fcvt_w_s,
	"fcvt.s.w":  fcvt_s_w,
	"fcvt.s.wu": fcvt_s_w,
	"fcvt.d.s":  fcvt_d_s,

	/* Abstraction */
	"auipc": auipc,
	"ret":   ret,
	"call":  call,
	"mv":    move,
}
var directives = map[string]func(*OutputWriter, []string){
	".asciz":  asciz,
	".string": asciz,
	".quad":   quad,
	".word":   word,
	".byte":   byte_,
	".half":   half,
}

func generateRegistryMap(w *OutputWriter, m map[string]bool) string {
	var sb strings.Builder

	keys := make([]string, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	sort.Slice(keys, func(i, j int) bool {
		ki, kj := keys[i], keys[j]

		// Compare first characters
		if ki[0] != kj[0] {
			return ki[0] > kj[0]
		}

		// Extract numeric suffix
		numI, _ := strconv.Atoi(ki[1:])
		numJ, _ := strconv.Atoi(kj[1:])

		return numI < numJ
	})

	for _, k := range keys {
		sb.WriteString(fmt.Sprintf("\t[\"%s\"] = 0,\n", k))
		//w.RegistryMap[k] = i
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
			if writer.Options.Comments {
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
		} else if writer.Options.Comments {
			WriteIndentedString(writer, "-- ASM DIRECTIVE: %s\n", command.Name)
		}
	}
	writer.CurrentLabel = ""
	WriteIndentedString(writer, "PC = %d\n", FindLabelAddress(writer, writer.Options.MainSymbol))
	WriteIndentedString(writer, "registers.x2 = (buffer.len(memory) + %d) / 2 -- start at the center after static data\n", writer.MemoryDevelopmentPointer)
	WriteIndentedString(writer, "if registers.x2 >= buffer.len(memory) then error(\"Not enough memory\") end\n")
	writer.Depth--
	WriteIndentedString(writer, "end\n")

	/* start code */
}
func AfterCompilation(writer *OutputWriter) []byte {
	AddEnd(writer) // end the current label, if active

	// check if invalid PC, then break
	WriteIndentedString(writer, "function main()\n")
	writer.Depth++
	WriteIndentedString(writer, "while FUNCS[PC] do\n")
	writer.Depth++
	WriteIndentedString(writer, "if not FUNCS[PC]() then\n")
	writer.Depth++
	WriteIndentedString(writer, "PC += 1\n")
	writer.Depth--
	WriteIndentedString(writer, "end\n")
	if writer.Options.Trace {
		WriteIndentedString(writer, "print(\"FALL THROUGH:\", PC)\n")
	}
	writer.Depth--
	WriteIndentedString(writer, "end\n")
	writer.Depth--
	WriteIndentedString(writer, "end\n")

	// final code based on mode
	if writer.Options.Mode == "main" {
		WriteString(writer, "init()\nmain()\n")
	} else if writer.Options.Mode == "module" {
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
		return_args = return_args,
		two_words_to_double = two_words_to_double,
		fclass = fclass,
	},
	PC = PC,
	registers = registers,
	data = data
}, {__call = function() init(); main() end})`)
	} else if writer.Options.Mode == "bench" {
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
	registers := generateRegistryMap(writer, baseRegs)
	extensions := generateExtensions(writer)

	replacer := strings.NewReplacer(
		"--{extentions here}", extensions,
		"--{registers here}", registers,
		"--{code here}", code,
	)
	return []byte(replacer.Replace(luau_boilerplate))

}
