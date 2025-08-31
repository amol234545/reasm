package compiler

import (
	"debug/elf"
	"io"
	"os"
	"strings"
)

type Options struct {
	Comments   bool
	Trace      bool
	Mode       string
	MainSymbol string
}

func Compile(executable *os.File, lang string, options Options) []byte {
	/* prepare */
	var writer = &OutputWriter{
		Buffer:                   []byte(""),
		CurrentLabel:             "",
		MemoryDevelopmentPointer: 0,
		MaxPC:                    1,
		DebugPC:                  options.Trace,
		DebugComments:            options.Comments,
		Mode:                     options.Mode,
		MainSymbol:               options.MainSymbol,
	}

	elf, err := elf.NewFile(executable)
	if err != nil {
		assembly, _ := io.ReadAll(executable)
		assembly_str := string(assembly)
		lines := strings.Split(assembly_str, "\n")

		/* parse */
		for _, line := range lines {
			var command AssemblyCommand = Parse(writer, line)
			writer.Commands = append(writer.Commands, command)
		}
	} else {
		writer.Commands = ParseFromElf(elf)
	}

	/* compilation */
	BeforeCompilation(writer)
	for _, command := range writer.Commands {
		CompileInstruction(writer, command)
	}
	return AfterCompilation(writer)
}
