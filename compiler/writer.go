package compiler

import (
	"fmt"
	"strings"
)

type PendingDataType int8

const (
	PendingDataTypeString PendingDataType = 0 /* a string generated via attribute */
)

type PendingData struct {
	Type PendingDataType
	Data string
}
type OutputWriter struct {
	Buffer                   []byte      /* the output */
	CurrentLabel             string      /* keep track of current label  */
	MemoryDevelopmentPointer int32       /* used when generating code that propagates memory with strings */
	PendingData              PendingData /* used for remember data across instructions */
	Depth                    int         /* used for indentation */
}

func WriteString(writer *OutputWriter, format string, args ...any) {
	writer.Buffer = append(writer.Buffer, fmt.Sprintf(format, args...)...)
}
func WriteIndentedString(writer *OutputWriter, format string, args ...any) {
	indent := strings.Repeat("\t", writer.Depth)
	writer.Buffer = append(writer.Buffer, indent+fmt.Sprintf(format, args...)...)
}
