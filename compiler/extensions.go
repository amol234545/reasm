package compiler

import (
	_ "embed"
	"strings"

	"github.com/sirupsen/logrus"
)

//go:embed math.luau
var math_extension string

var extensions = map[string]string{
	"math": math_extension,
}

func generateExtensions(writer *OutputWriter) string {
	var sb strings.Builder

	for _, name := range writer.Options.Imports {
		if ext, ok := extensions[name]; ok {
			sb.WriteString(ext)
			sb.WriteString("\n")
		} else {
			logrus.Warnf("unknown import: %s", name)
		}
	}

	return sb.String()
}
