package compiler

import (
	"strings"
)

var enders = map[string]func(*OutputWriter) []byte{
	"luau": EndLuau,
}
var compilers = map[string]func(*OutputWriter, AssemblyCommand){
	"luau": CompileLuau,
}
var starters = map[string]func(*OutputWriter){
	"luau": StartLuau,
}

func Compile(assembly []byte, lang string) []byte {
	var assembly_str string = string(assembly)

	lines := strings.Split(assembly_str, "\n")

	/* compile line by line */
	var writer = &OutputWriter{Buffer: []byte(""), CurrentLabel: "", MemoryDevelopmentPointer: 0}
	starters[lang](writer)
	for _, line := range lines {
		var command AssemblyCommand = Parse(line)

		compilers[lang](writer, command)
	}

	return enders[lang](writer)
}
