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
	if w.CurrentLabel != "" {
		WriteString(w, "end -- %s (%s)\n", w.LabelCorrespondence[w.CurrentLabel], w.CurrentLabel)
	}
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
	_, err := strconv.ParseInt(argument.Source, 10, 8)
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

/* instructions */
/** todo: handle wraparounds for where it cuts lower or upper bits, also add support for hi and low */

/* basic */
func label(w *OutputWriter, command AssemblyCommand) {
	if strings.HasPrefix(command.Name, ".L") {
		add_end(w)
		w.CurrentLabel = ""
		return
	}

	/* has this label been defined already? */
	corr := w.LabelCorrespondence[command.Name]
	if corr != "" {
		panic("Label already defined")
	}

	/* end previous label */
	add_end(w)

	/* define it */
	newCor := RandomVar()
	if command.Name == "main" { /* preserve main */
		newCor = "main"
	}
	w.LabelCorrespondence[newCor] = command.Name
	w.CurrentLabel = newCor

	WriteString(w, "function %s() -- %s\n", newCor, command.Name)
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
	WriteIndentedString(w, "return\n")
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
	if w.LabelCorrespondence[function] == "" {
		WriteIndentedString(w, "functions[\"%s\"]() -- invoke provided function %s\n", function, function)
	} else {
		WriteIndentedString(w, "%s() -- invoke %s\n", w.LabelCorrespondence[function], function)
	}
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
func sub(w *OutputWriter, command AssemblyCommand) { /* add & addi instructions */
	WriteIndentedString(w, "registers[\"%s\"] = %s - %s\n", command.Arguments[0].Source, compile_register(command.Arguments[1]), compile_register(command.Arguments[2]))
}

/* map instructions */
var instructions = map[string]func(*OutputWriter, AssemblyCommand){
	"ret":  ret,
	"sw":   sw,
	"li":   li,
	"lw":   lw,
	"sh":   sh,
	"lui":  lui,
	"call": call,
	"slli": slli,
	"srli": srli,
	"add":  add,
	"addi": add,
	"sub":  add,
	"subi": sub,
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
			WriteIndentedString(writer, "-- unknown command: %s (%v)\n", command.Name, command.Arguments)
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
func FormatLuau(writer *OutputWriter) []byte {
	add_end(writer) // end the current label
	return []byte(strings.Replace(luau_boilerplate, "--{code here}", string(writer.Buffer), 1))
}
