package compiler

import (
	"math/rand"
	"regexp"
	"strings"
)

func RandomVar() string {
	const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	const alphanumeric = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

	name := []byte{letters[rand.Intn(len(letters))]}

	for i := 1; i < 8; i++ {
		name = append(name, alphanumeric[rand.Intn(len(alphanumeric))])
	}

	return string(name)
}
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
