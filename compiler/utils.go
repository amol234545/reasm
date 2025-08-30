package compiler

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

func ReadAttribute(attribute string) []string {
	// Regex: match either "quoted strings" or sequences of non-comma, non-whitespace characters
	re := regexp.MustCompile(`"([^"]*)"|[^,\s]+`)
	matches := re.FindAllString(attribute, -1)

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

	w.Depth--
	WriteIndentedString(w, "end -- %s (%s)\n", w.CurrentLabel, w.CurrentLabel)
}
func CompileMacro(data string) string {
	var compiled string
	if strings.HasPrefix(data, ".L.") { /* string */
		cut, _ := strings.CutPrefix(data, ".L.")
		compiled = fmt.Sprintf("data[\"%s\"]", cut)
	}

	return compiled
}
func CompileRegister(argument Argument) string {
	/* does it work as a integer (its a plain) */
	_, err := strconv.Atoi(argument.Source)
	if err == nil {
		return argument.Source
	}

	/* Try macros (.L.) */
	var compiled = CompileMacro(argument.Source)
	if compiled == "" {
		compiled = fmt.Sprintf("registers.%s", argument.Source)
	}

	/** Offset */
	if argument.Offset != 0 {
		compiled = fmt.Sprintf("%s+%d", compiled, argument.Offset)
	}

	/** Modifier */
	if argument.Modifier != "" {
		compiled = fmt.Sprintf("%s(%s)", argument.Modifier, compiled)
	}

	return compiled
}
func JumpTo(w *OutputWriter, label string, link bool) {
	if link {
		WriteIndentedString(w, "registers.ra = %d\n", w.MaxPC)
	}
	WriteIndentedString(w, "PC = labels[\"%s\"]\n", label)
	WriteIndentedString(w, "continue\n")
}
func CutAndLink(w *OutputWriter) {
	AddEnd(w)
	WriteIndentedString(w, "if PC == %d and not init then -- %s (extended) \n", w.MaxPC, w.CurrentLabel)
	w.Depth++
	w.MaxPC++
	w.CurrentLabel = fmt.Sprintf("%s_end", w.CurrentLabel)
	w.Labels = append(w.Labels, w.CurrentLabel)
}
func FindInArray(array []string, target string) int {
	for i, item := range array {
		if item == target {
			return i
		}
	}
	return -1
}
