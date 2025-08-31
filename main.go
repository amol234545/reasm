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
	var outputFile string
	var mainSymbol string

	var rootCmd = &cobra.Command{
		Use:   "cli [input] [output]",
		Short: "CLI tool to decompile assembly.",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, inputFiles []string) error {
			validModes := []string{"module", "main", "bench"}
			modeLower := strings.ToLower(mode)
			if !slices.Contains(validModes, modeLower) {
				return fmt.Errorf("invalid mode: %s. Valid modes are: module, main, bench", mode)
			}

			/* read input file */
			var allData [][]byte

			for _, inputFile := range inputFiles {
				data, err := os.ReadFile(inputFile)
				if err != nil {
					return fmt.Errorf("failed to read input file: %w", err)
				}
				allData = append(allData, data)
			}

			/* compile with options */
			processed := compiler.Compile(allData, lang, compiler.Options{
				Comments:   enableComments,
				Trace:      enableTrace,
				Mode:       modeLower,
				MainSymbol: mainSymbol,
			})

			/* write output file */
			err := os.WriteFile(outputFile, processed, 0644)
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
	rootCmd.Flags().StringVarP(&outputFile, "output", "o", "", "The output luau file.")
	rootCmd.Flags().StringVarP(&mainSymbol, "symbol", "e", "main", "The main symbol to start automatically.")
	rootCmd.MarkFlagRequired("o")

	rootCmd.Execute()
}
