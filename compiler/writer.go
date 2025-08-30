package compiler

import (
	"fmt"
	"strings"
)

type PendingDataType int8

const (
	PendingDataTypeNone    PendingDataType = 0
	PendingDataTypeString  PendingDataType = 1 /* a string generated via attribute */
	PendingDataTypeNumeric PendingDataType = 2 /* a numeric value generated via .word for example */
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
	Labels                   []string    /* used for labels */
	MaxPC                    int         /* used for counting PC which is hardcoded in */

	/* debug options */
	DebugPC       bool /* code will print the program counter */
	DebugComments bool /* code will be commented with the original instruction and other notes */
}

func WriteString(writer *OutputWriter, format string, args ...any) {
	writer.Buffer = append(writer.Buffer, fmt.Sprintf(format, args...)...)
}
func WriteIndentedString(writer *OutputWriter, format string, args ...any) {
	indent := strings.Repeat("\t", writer.Depth)
	writer.Buffer = append(writer.Buffer, indent+fmt.Sprintf(format, args...)...)
}
