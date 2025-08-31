package compiler

import (
	"strings"
)

type Options struct {
	Comments bool
	Trace    bool
}

func Compile(assembly []byte, lang string, options Options) []byte {
	var assembly_str string = string(assembly)

	lines := strings.Split(assembly_str, "\n")

	/* compile line by line */
	var writer = &OutputWriter{Buffer: []byte(""), CurrentLabel: "", MemoryDevelopmentPointer: 0, MaxPC: 1, DebugPC: options.Trace, DebugComments: options.Comments}
	BeforeCompilation(writer)
	for _, line := range lines {
		var command AssemblyCommand = Parse(line)

		CompileInstruction(writer, command)
	}

	return AfterCompilation(writer)
}
