package compiler

import (
	_ "embed"
	"fmt"
	"strconv"
	"strings"
)

//go:embed boilerplate.luau
var luau_boilerplate string

/* util */
func add_end(w *OutputWriter) {
	if w.CurrentLabel == "" {
		return
	}

	w.Depth--
	WriteIndentedString(w, "end -- %s (%s)\n", w.CurrentLabel, w.CurrentLabel)
}
func compile_macro_data(data string) string {
	var compiled string
	if strings.HasPrefix(data, ".L.") { /* string */
		cut, _ := strings.CutPrefix(data, ".L.")
		compiled = fmt.Sprintf("data[\"%s\"]", cut)
	}

	return compiled
}
func compile_register(argument Argument) string {
	/* does it work as a integer (its a plain) */
	_, err := strconv.Atoi(argument.Source)
	if err == nil {
		return argument.Source
	}

	/* Try macros (.L.) */
	var compiled = compile_macro_data(argument.Source)
	if compiled == "" {
		compiled = fmt.Sprintf("registers[\"%s\"]", argument.Source)
	}

	/** Offset */
	if argument.Offset != 0 {
		compiled = fmt.Sprintf("%s+%d", compiled, argument.Offset)
	}

	/** Modifier */
	if argument.Modifier != "" {
		compiled = fmt.Sprintf("%s(%s)", argument.Modifier, compiled)
	}

	return compiled
}
func jump_to(w *OutputWriter, label string) {
	WriteIndentedString(w, "PC = \"%s\"\n", label)
}

/* instructions */
/** todo: handle wraparounds for where it cuts lower or upper bits, also add support for hi and low */

/* basic */
func label(w *OutputWriter, command AssemblyCommand) {
	/* end previous label */
	add_end(w)

	/* define it */
	w.CurrentLabel = command.Name

	if strings.HasPrefix(command.Name, ".L.") {
		WriteIndentedString(w, "if init then -- %s (initialization)\n", command.Name)
	} else {
		WriteIndentedString(w, "if PC == \"%s\" and not init then -- %s (runtime) \n", command.Name, command.Name)
	}
	w.Depth++
}

/* attributes */
func asciz(w *OutputWriter, components []string) {
	var data = strings.Trim(components[1], "\"")
	w.PendingData.Data = data
	w.PendingData.Type = PendingDataTypeString
}
func size(w *OutputWriter, components []string) {
	data := w.PendingData.Data
	dataType := w.PendingData.Type

	macro := compile_macro_data(components[1])

	if macro == "" {
		return
	}

	if dataType == PendingDataTypeString {
		/* define a string */
		WriteIndentedString(w, "buffer.writestring(memory, %d, \"%s\\0\")\n", w.MemoryDevelopmentPointer, data)
		WriteIndentedString(w, "%s = %d -- represents ^\n", macro, w.MemoryDevelopmentPointer)

		w.MemoryDevelopmentPointer += int32(len(data) + 1)
	}
}

/* instructions */
func ret(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "break\n")
}
func sw(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "buffer.writei32(memory, %s, %s)\n", compile_register(command.Arguments[1]), compile_register(command.Arguments[0]))
}
func sh(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "buffer.writei16(memory, %s, %s)\n", compile_register(command.Arguments[1]), compile_register(command.Arguments[0]))
}
func li(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = %s\n", command.Arguments[0].Source, compile_register(command.Arguments[1]))
}
func lw(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = buffer.readi32(memory, %s)\n", command.Arguments[0].Source, compile_register(command.Arguments[1]))
}
func lui(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = %s\n", command.Arguments[0].Source, compile_register(command.Arguments[1]))
}
func call(w *OutputWriter, command AssemblyCommand) {
	var function = command.Arguments[0].Source
	WriteIndentedString(w, "functions[\"%s\"]() -- invoke provided function %s\n", function, function)
}
func slli(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = bit32.band(bit32.lshift(%s, %s), 0xFFFFFFFF)\n", command.Arguments[0].Source, compile_register(command.Arguments[1]), compile_register(command.Arguments[2]))
}
func srli(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = bit32.band(bit32.rshift(%s, %s), 0xFFFFFFFF)\n", command.Arguments[0].Source, compile_register(command.Arguments[1]), compile_register(command.Arguments[2]))
}
func add(w *OutputWriter, command AssemblyCommand) { /* add & addi instructions */
	WriteIndentedString(w, "registers[\"%s\"] = %s + %s\n", command.Arguments[0].Source, compile_register(command.Arguments[1]), compile_register(command.Arguments[2]))
}
func sub(w *OutputWriter, command AssemblyCommand) { /* sub & subi instructions */
	WriteIndentedString(w, "registers[\"%s\"] = %s - %s\n", command.Arguments[0].Source, compile_register(command.Arguments[1]), compile_register(command.Arguments[2]))
}
func jump(w *OutputWriter, command AssemblyCommand) { /* j instructions */
	jump_to(w, command.Arguments[0].Source)
}
func blt(w *OutputWriter, command AssemblyCommand) { /* blt & blti instructions */
	WriteIndentedString(w, "if %s < %s then\n", compile_register(command.Arguments[0]), compile_register(command.Arguments[1]))
	w.Depth++
	jump_to(w, command.Arguments[2].Source)
	WriteIndentedString(w, "continue\n")
	w.Depth--
	WriteIndentedString(w, "end\n")
}
func and(w *OutputWriter, command AssemblyCommand) { /* and & andi instructions */
	WriteIndentedString(w, "registers[\"%s\"] = bit32.band(%s, %s)\n", command.Arguments[0].Source, compile_register(command.Arguments[1]), compile_register(command.Arguments[2]))
}
func bnez(w *OutputWriter, command AssemblyCommand) { /* bnez & bnezi instructions */
	WriteIndentedString(w, "if %s ~= 0 then\n", compile_register(command.Arguments[0]))
	w.Depth++
	jump_to(w, command.Arguments[1].Source)
	WriteIndentedString(w, "continue\n")
	w.Depth--
	WriteIndentedString(w, "end\n")
}
func bge(w *OutputWriter, command AssemblyCommand) { /* bge & bgei instructions */
	WriteIndentedString(w, "if %s >= %s then\n", compile_register(command.Arguments[0]), compile_register(command.Arguments[1]))
	w.Depth++
	jump_to(w, command.Arguments[2].Source)
	WriteIndentedString(w, "continue\n")
	w.Depth--
	WriteIndentedString(w, "end\n")
}
func slt(w *OutputWriter, command AssemblyCommand) { /* sltu & sltui instructions */
	WriteIndentedString(w, "registers[\"%s\"] = if (%s < %s) then 1 else 0\n", command.Arguments[0].Source, compile_register(command.Arguments[1]), compile_register(command.Arguments[2]))
}
func srai(w *OutputWriter, command AssemblyCommand) { /* srai & srari instructions */
	WriteIndentedString(w, "registers[\"%s\"] = bit32.arshift(%s, %s)\n", command.Arguments[0].Source, compile_register(command.Arguments[1]), compile_register(command.Arguments[2]))
}

/* map instructions */
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
	"bnez":  bnez,
	"and":   and,
	"andi":  and,
	"slt":   slt,
	"sltu":  slt,
	"sltiu": slt,
	"srai":  srai,
	"bge":   bge,
}
var attributes = map[string]func(*OutputWriter, []string){
	".asciz": asciz,
	".size":  size,
}

/* main */
func CompileLuau(writer *OutputWriter, command AssemblyCommand) {
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
func StartLuau(writer *OutputWriter) {
	WriteIndentedString(writer, "while PC do\n")
	writer.Depth++
}
func EndLuau(writer *OutputWriter) []byte {
	add_end(writer) // end the current label, if active
	// end the while loop we initialized in StartLuau
	WriteIndentedString(writer, "init = false\n")
	writer.Depth--
	WriteIndentedString(writer, "end")

	return []byte(strings.Replace(luau_boilerplate, "--{code here}", string(writer.Buffer), 1))
}
