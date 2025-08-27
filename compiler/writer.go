package compiler

import (
	"fmt"
)

type PendingDataType int8

const (
	PendingDataTypeString PendingDataType = 0
)

type PendingData struct {
	Type PendingDataType
	Data string
}
type OutputWriter struct {
	Buffer                   []byte            /* the output */
	LabelCorrespondence      map[string]string /* a map of all the labels ASM name to their "fake" name */
	CurrentLabel             string            /* keep track of current label  */
	MemoryDevelopmentPointer int32             /* used when generating code that propagates memory with strings */
	PendingData              PendingData
}

func WriteString(writer *OutputWriter, format string, args ...any) {
	writer.Buffer = append(writer.Buffer, fmt.Sprintf(format, args...)...)
}
func WriteIndentedString(writer *OutputWriter, format string, args ...any) {
	indent := ""
	if writer.CurrentLabel != "" {
		indent = "\t"
	}
	writer.Buffer = append(writer.Buffer, indent+fmt.Sprintf(format, args...)...)
}
