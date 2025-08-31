package compiler

import (
	"strings"
)

type Options struct {
	Comments bool
	Trace    bool
	Mode     string
}

func Compile(assembly []byte, lang string, options Options) []byte {
	var assembly_str string = string(assembly)

	lines := strings.Split(assembly_str, "\n")

	/* prepare */
	var writer = &OutputWriter{Buffer: []byte(""), CurrentLabel: "", MemoryDevelopmentPointer: 0, MaxPC: 1, DebugPC: options.Trace, DebugComments: options.Comments, Mode: options.Mode}

	/* parse */
	var commands []AssemblyCommand
	for _, line := range lines {
		var command AssemblyCommand = Parse(line)
		commands = append(commands, command)
	}
	writer.Commands = commands

	/* compilation */
	BeforeCompilation(writer)
	for _, command := range commands {
		CompileInstruction(writer, command)
	}
	return AfterCompilation(writer)
}
