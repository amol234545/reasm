package compiler

import "strings"

func label(w *OutputWriter, command AssemblyCommand) {
	/* end previous label */
	AddEnd(w)

	/* define it */
	w.CurrentLabel = command.Name

	if strings.HasPrefix(command.Name, ".L.") {
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
		WriteIndentedString(w, "%s = %d -- represents ^\n", macro, w.MemoryDevelopmentPointer)

		w.MemoryDevelopmentPointer += int32(len(data) + 1)
	}
}
