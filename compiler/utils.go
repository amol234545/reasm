package compiler

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

func ReadDirective(directive string) []string {
	// Regex: match either "quoted strings" or sequences of non-comma, non-whitespace characters
	re := regexp.MustCompile(`"([^"]*)"|[^,\s]+`)
	matches := re.FindAllString(directive, -1)

	// Remove quotes and trim spaces
	for i, match := range matches {
		matches[i] = strings.TrimSpace(strings.Trim(match, `"`))
	}

	return matches
}
func AddEnd(w *OutputWriter) {
	if w.CurrentLabel == "" {
		return
	}

	WriteIndentedString(w, "PC += 1\n")
	w.Depth--
	if w.DebugComments {
		WriteIndentedString(w, "end -- %s (%s)\n", w.CurrentLabel, w.CurrentLabel)
	} else {
		WriteIndentedString(w, "end\n")
	}
}
func CompileRegister(argument Argument) string {
	/* does it work as a integer (its a plain) */
	_, err := strconv.Atoi(argument.Source)
	if err == nil {
		return argument.Source
	}

	var compiled string = fmt.Sprintf("data[\"%s\"]", argument.Source) /* assume it is raw data originally */
	if isRegister(argument.Source) {                                   /* it is a register! */
		compiled = fmt.Sprintf("registers.%s", argument.Source)

		/** Offset */
		if argument.Offset != 0 {
			compiled = fmt.Sprintf("%s+%d", compiled, argument.Offset)
		}
	}

	/** Modifier */
	if argument.Modifier != "" {
		compiled = fmt.Sprintf("%s(%s)", argument.Modifier, compiled)
	}
	return compiled
}
func JumpTo(w *OutputWriter, label string, link bool) {
	WriteIndentedString(w, "do\n")
	w.Depth++
	if link {
		WriteIndentedString(w, "registers.ra = %d\n", w.MaxPC)
	}
	if w.DebugComments {
		WriteIndentedString(w, "PC = %d -- %s\n", FindLabelAddress(w, label), label)
	} else {
		WriteIndentedString(w, "PC = %d\n", FindLabelAddress(w, label))
	}
	if w.DebugPC {
		WriteIndentedString(w, "print(PC)\n")
	}
	WriteIndentedString(w, "continue\n")
	w.Depth--
	WriteIndentedString(w, "end\n")
}
func CutAndLink(w *OutputWriter) {
	AddEnd(w)
	WriteIndentedString(w, "if PC == %d then -- %s (extended) \n", w.MaxPC, w.CurrentLabel)
	w.Depth++
	w.MaxPC++
	w.CurrentLabel = fmt.Sprintf("%s_end", w.CurrentLabel)
}
func FindInArray(array []string, target string) int {
	for i, item := range array {
		if item == target {
			return i
		}
	}
	return -1
}

func isCutoffInstruction(instruction AssemblyCommand) bool {
	return instruction.Type == Instruction && (instruction.Name == "call" || instruction.Name == "jal" || instruction.Name == "jalr")
}

func FindLabelAddress(writer *OutputWriter, target string) int {
	countedLabels := 0
	for _, label := range writer.Commands {
		if label.Type == Label || isCutoffInstruction(label) {
			countedLabels++ // our labels are Lua indexed starting at 1
		}
		if label.Type == Label && label.Name == target {
			return countedLabels
		}
	}
	return -1
}

func IsLabelEmpty(writer *OutputWriter, label string) bool {
	reachedLabel := false
	for _, command := range writer.Commands {
		if command.Type == Instruction && reachedLabel { /* found something in our bounds */
			return true
		}

		if command.Type == Label {
			if command.Name == label { /* it is our turn! */
				reachedLabel = true
			} else if reachedLabel { /* we passed another label, our time is up */
				return false
			}
		}
	}

	return false
}
