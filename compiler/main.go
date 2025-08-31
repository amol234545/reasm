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

	/* prepare */
	var writer = &OutputWriter{Buffer: []byte(""), CurrentLabel: "", MemoryDevelopmentPointer: 0, MaxPC: 1, DebugPC: options.Trace, DebugComments: options.Comments}
	BeforeCompilation(writer)

	/* parse */
	var commands []AssemblyCommand
	for _, line := range lines {
		var command AssemblyCommand = Parse(line)
		commands = append(commands, command)
	}
	writer.Commands = commands

	/* compilation */
	for _, command := range commands {
		CompileInstruction(writer, command)
	}

	/* complete */
	return AfterCompilation(writer)
}
