package compiler

import (
	"fmt"
	"strconv"
	"strings"
)

func label(w *OutputWriter, command AssemblyCommand) {
	// if IsLabelEmpty(w, command.Name) {
	// 	return
	// }

	/* end previous label */
	AddEnd(w)

	/* define it */
	w.CurrentLabel = command.Name

	WriteIndentedString(w, "if PC == %d then -- %s\n", w.MaxPC, command.Name)
	w.Depth++
	w.MaxPC++
}

func asciz(w *OutputWriter, components []string) {
	var data = strings.Trim(components[1], "\"")
	w.PendingData.Data = data
	w.PendingData.Type = PendingDataTypeString
}
func size(w *OutputWriter, components []string) {
	data := w.PendingData.Data
	dataType := w.PendingData.Type

	macro := fmt.Sprintf("data[\"%s\"]", components[1])

	if macro == "" {
		return
	}

	if dataType == PendingDataTypeString {
		/* define a string */
		WriteIndentedString(w, "writestring(memory, %d, \"%s\\0\")\n", w.MemoryDevelopmentPointer, data)
		WriteIndentedString(w, "%s = %d\n", macro, w.MemoryDevelopmentPointer)

		w.MemoryDevelopmentPointer += int32(len(data) + 1)
	} else if dataType == PendingDataTypeNumeric {
		/* define a number */
		dataInt, _ := strconv.Atoi(data)
		WriteIndentedString(w, "%s = %d\n", macro, dataInt)
	}

	w.PendingData.Type = PendingDataTypeNone
}
func word(w *OutputWriter, components []string) {
	if w.PendingData.Type != PendingDataTypeNumeric {
		w.PendingData.Data = strconv.Itoa(int(w.MemoryDevelopmentPointer)) /* i lowkey dont wanna deal with string|number union somehow */
	}
	w.PendingData.Type = PendingDataTypeNumeric

	val, _ := strconv.Atoi(components[1])
	WriteIndentedString(w, "writei32(memory, %d, %d)\n", w.MemoryDevelopmentPointer, val)

	w.MemoryDevelopmentPointer += 4
}
func half(w *OutputWriter, components []string) {
	if w.PendingData.Type != PendingDataTypeNumeric {
		w.PendingData.Data = strconv.Itoa(int(w.MemoryDevelopmentPointer)) /* i lowkey dont wanna deal with string|number union somehow */
	}
	w.PendingData.Type = PendingDataTypeNumeric

	val, _ := strconv.Atoi(components[1])
	WriteIndentedString(w, "writei16(memory, %d, %d)\n", w.MemoryDevelopmentPointer, val)

	w.MemoryDevelopmentPointer += 2
}
func byte_(w *OutputWriter, components []string) { /* byte_ to avoid overlap with the type */
	if w.PendingData.Type != PendingDataTypeNumeric {
		w.PendingData.Data = strconv.Itoa(int(w.MemoryDevelopmentPointer)) /* i lowkey dont wanna deal with string|number union somehow */
	}
	w.PendingData.Type = PendingDataTypeNumeric

	val, _ := strconv.Atoi(components[1])
	WriteIndentedString(w, "writei16(memory, %d, %d)\n", w.MemoryDevelopmentPointer, val)

	w.MemoryDevelopmentPointer += 1
}
func globl(w *OutputWriter, components []string) {
	WriteIndentedString(w, "PC = %d\n", FindLabelAddress(w, components[1]))
}
