package compiler

import (
	"strings"
)

func Compile(assembly []byte, lang string) []byte {
	var assembly_str string = string(assembly)

	lines := strings.Split(assembly_str, "\n")

	/* compile line by line */
	var writer = &OutputWriter{Buffer: []byte(""), CurrentLabel: "", MemoryDevelopmentPointer: 0, MaxPC: 1}
	BeforeCompilation(writer)
	for _, line := range lines {
		var command AssemblyCommand = Parse(line)

		CompileInstruction(writer, command)
	}

	return AfterCompilation(writer)
}
