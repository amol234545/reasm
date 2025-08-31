package main

import (
	"fmt"
	"os"
	"slices"
	"strings"

	"github.com/AsynchronousAI/asm-decomp/compiler"
	"github.com/spf13/cobra"
)

func main() {
	var lang string
	var enableComments bool
	var enableTrace bool
	var mode string

	var rootCmd = &cobra.Command{
		Use:   "cli [input] [output]",
		Short: "CLI tool to decompile assembly.",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			validModes := []string{"module", "main", "bench"}
			modeLower := strings.ToLower(mode)
			if !slices.Contains(validModes, modeLower) {
				return fmt.Errorf("invalid mode: %s. Valid modes are: module, main, bench", mode)
			}

			inputFile := args[0]
			outputFile := args[1]

			/* read input file */
			data, err := os.ReadFile(inputFile)
			if err != nil {
				return fmt.Errorf("failed to read input file: %w", err)
			}

			/* compile with options */
			processed := compiler.Compile(data, lang, compiler.Options{
				Comments: enableComments,
				Trace:    enableTrace,
				Mode:     modeLower,
			})

			/* write output file */
			err = os.WriteFile(outputFile, processed, 0644)
			if err != nil {
				return fmt.Errorf("failed to write output file: %w", err)
			}

			return nil
		},
	}

	// Flags
	rootCmd.Flags().StringVar(&lang, "lang", "luau", "Language to compile to (default: luau)")
	rootCmd.Flags().BoolVar(&enableComments, "comments", false, "Include debug comments in the output")
	rootCmd.Flags().BoolVar(&enableTrace, "trace", false, "Prints out a trace of the PC")
	rootCmd.Flags().StringVar(&mode, "mode", "main", "Mode to compile as: module, main, or bench (default: main)")

	rootCmd.Execute()
}
