package main

import (
	"fmt"
	"os"

	"github.com/AsynchronousAI/asm-decomp/compiler"
	"github.com/spf13/cobra"
)

func main() {
	var lang string // variable to hold the flag value

	var rootCmd = &cobra.Command{
		Use:   "cli [input] [output]",
		Short: "CLI tool to decompile assembly.",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			inputFile := args[0]
			outputFile := args[1]

			/* read */
			data, err := os.ReadFile(inputFile)
			if err != nil {
				return fmt.Errorf("failed to read input file: %w", err)
			}

			/* compile */
			processed := compiler.Compile(data, lang)

			/* write */
			err = os.WriteFile(outputFile, processed, 0644)
			if err != nil {
				return fmt.Errorf("failed to write output file: %w", err)
			}

			return nil
		},
	}

	rootCmd.Flags().StringVar(&lang, "lang", "luau", "Language to compile to (default: luau)")

	rootCmd.Execute()
}
