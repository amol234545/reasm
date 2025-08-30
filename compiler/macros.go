package compiler

import (
	"strconv"
	"strings"
)

func label(w *OutputWriter, command AssemblyCommand) {
	/* end previous label */
	AddEnd(w)

	/* define it */
	w.CurrentLabel = command.Name

	if strings.HasPrefix(command.Name, ".L.") || strings.HasPrefix(command.Name, ".L_") { /* TODO: use a preprocessor to analyze */
		WriteIndentedString(w, "if init then -- %s (initialization)\n", command.Name)
	} else {
		WriteIndentedString(w, "if PC == %d and not init then -- %s (runtime) \n", w.MaxPC, command.Name)
	}
	w.Depth++
	w.MaxPC++
	w.Labels = append(w.Labels, command.Name)
}

func asciz(w *OutputWriter, components []string) {
	var data = strings.Trim(components[1], "\"")
	w.PendingData.Data = data
	w.PendingData.Type = PendingDataTypeString
}
func size(w *OutputWriter, components []string) {
	data := w.PendingData.Data
	dataType := w.PendingData.Type

	macro := CompileMacro(components[1])

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
