package compiler

import (
	"regexp"
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
