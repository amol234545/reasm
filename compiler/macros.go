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

	WriteIndentedString(w, "if PC == %d then -- %s\n", w.MaxPC, command.Name)
	w.Depth++
	w.MaxPC++
}

func save_pointer(w *OutputWriter) {
	WriteIndentedString(w, "data[\"%s\"] = %d\n", w.CurrentLabel, int(w.MemoryDevelopmentPointer))
}

func asciz(w *OutputWriter, components []string) {
	var data = strings.Trim(components[1], "\"")
	w.PendingData.Data = data
	w.PendingData.Type = PendingDataTypeString

	WriteIndentedString(w, "writestring(memory, %d, \"%s\\0\")\n", w.MemoryDevelopmentPointer, data)
	save_pointer(w)
	w.MemoryDevelopmentPointer += int32(len(data) + 1)
}
func quad(w *OutputWriter, components []string) {
	if w.PendingData.Type != PendingDataTypeNumeric {
		w.PendingData.Data = strconv.Itoa(int(w.MemoryDevelopmentPointer))
		save_pointer(w)
	}
	w.PendingData.Type = PendingDataTypeNumeric

	val, _ := strconv.ParseInt(components[1], 0, 0)
	WriteIndentedString(w, "writei32(memory, %d, %d)\n", w.MemoryDevelopmentPointer, val&0xFFFFFFFF)
	WriteIndentedString(w, "writei32(memory, %d, %d)\n", w.MemoryDevelopmentPointer+4, val>>32)

	w.MemoryDevelopmentPointer += 8
}
func word(w *OutputWriter, components []string) {
	if w.PendingData.Type != PendingDataTypeNumeric {
		w.PendingData.Data = strconv.Itoa(int(w.MemoryDevelopmentPointer))
		save_pointer(w)
	}
	w.PendingData.Type = PendingDataTypeNumeric

	val, _ := strconv.ParseInt(components[1], 0, 0)
	WriteIndentedString(w, "writei32(memory, %d, %d)\n", w.MemoryDevelopmentPointer, val)

	w.MemoryDevelopmentPointer += 4
}
func half(w *OutputWriter, components []string) {
	if w.PendingData.Type != PendingDataTypeNumeric {
		w.PendingData.Data = strconv.Itoa(int(w.MemoryDevelopmentPointer))
		save_pointer(w)
	}
	w.PendingData.Type = PendingDataTypeNumeric

	val, _ := strconv.ParseInt(components[1], 0, 0)
	WriteIndentedString(w, "writei16(memory, %d, %d)\n", w.MemoryDevelopmentPointer, val)

	w.MemoryDevelopmentPointer += 2
}
func byte_(w *OutputWriter, components []string) { /* byte_ to avoid overlap with the type */
	if w.PendingData.Type != PendingDataTypeNumeric {
		w.PendingData.Data = strconv.Itoa(int(w.MemoryDevelopmentPointer))
		save_pointer(w)
	}
	w.PendingData.Type = PendingDataTypeNumeric

	val, _ := strconv.ParseInt(components[1], 0, 0)
	WriteIndentedString(w, "writei16(memory, %d, %d)\n", w.MemoryDevelopmentPointer, val)

	w.MemoryDevelopmentPointer += 1
}
