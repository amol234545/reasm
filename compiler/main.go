package compiler

import (
	"strings"
)

var compilers = map[string]func(*OutputWriter, AssemblyCommand){
	"luau": CompileLuau,
}
var enders = map[string]func(*OutputWriter) []byte{
	"luau": EndLuau,
}

func Compile(assembly []byte, lang string) []byte {
	var assembly_str string = string(assembly)

	lines := strings.Split(assembly_str, "\n")

	/* compile line by line */
	var writer = &OutputWriter{Buffer: []byte(""), LabelCorrespondence: make(map[string]string), CurrentLabel: "", MemoryDevelopmentPointer: 0}
	for _, line := range lines {
		var command AssemblyCommand = Parse(line)

		compilers[lang](writer, command)
	}

	return enders[lang](writer)
}
