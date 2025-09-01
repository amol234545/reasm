package compiler

import (
	"regexp"
	"strconv"
	"strings"
)

var offsetReg = regexp.MustCompile(`^(-?\d+)?\((\w+)\)$`)
var modifierReg = regexp.MustCompile(`^%(hi|lo)\((.+)\)$`)

type Argument struct {
	Offset   int8
	Register bool
	Source   string
	Modifier string /* "lo", "hi", or "" */
}
type CommandType uint8

const (
	Instruction CommandType = 0
	Label       CommandType = 1
	Directive   CommandType = 2
)

type AssemblyCommand struct {
	Type      CommandType
	Name      string
	Arguments []Argument
}

func Parse(writer *OutputWriter, command string) AssemblyCommand {
	// Remove comments
	if idx := strings.IndexAny(command, ";#"); idx != -1 {
		command = command[:idx]
	}

	cmd := strings.TrimSpace(command)

	// Empty line
	if cmd == "" {
		return AssemblyCommand{Type: Instruction}
	}

	// Label (ends with ':')
	if strings.HasSuffix(cmd, ":") {
		name := strings.TrimSuffix(cmd, ":")
		return AssemblyCommand{Type: Label, Name: name}
	}

	// Directive (.something ...)
	if strings.HasPrefix(cmd, ".") {
		name := cmd
		args := make([]Argument, 0)
		return AssemblyCommand{Type: Directive, Name: name, Arguments: args}
	}

	// Regular instruction (command)
	parts := strings.Fields(cmd)
	name := parts[0]
	args := parseArguments(parts[1:])

	return AssemblyCommand{Type: Instruction, Name: name, Arguments: args}
}

func parseArguments(parts []string) []Argument {
	if len(parts) == 0 {
		return nil
	}

	joined := strings.Join(parts, " ")
	pieces := strings.Split(joined, ",")

	args := []Argument{}
	for _, p := range pieces {
		p = strings.TrimSpace(p)
		if p == "" {
			continue
		}

		arg := Argument{}

		// Check for %hi(...) or %lo(...) pattern
		if matches := modifierReg.FindStringSubmatch(p); matches != nil {
			arg.Modifier = matches[1] // "hi" or "lo"
			p = matches[2]            // content inside parentheses
		}

		arg.Source = p // store the raw source

		// Check for offset(register) pattern inside source
		isReg, reg := isRegister(p)
		if matches := offsetReg.FindStringSubmatch(p); matches != nil {
			arg.Register = true
			arg.Source = matches[2] // register name only
			if matches[1] != "" {
				if val, err := strconv.Atoi(matches[1]); err == nil {
					arg.Offset = int8(val)
				}
			} else {
				arg.Offset = 0
			}
		} else if isReg { // standalone register
			arg.Register = true
			arg.Offset = 0
			arg.Source = reg
		}

		args = append(args, arg)
	}
	return args
}

var baseRegs = map[string]bool{
	"x0":  true,
	"x1":  true,
	"x2":  true,
	"x3":  true,
	"x4":  true,
	"x5":  true,
	"x6":  true,
	"x7":  true,
	"x8":  true,
	"x9":  true,
	"x10": true,
	"x11": true,
	"x12": true,
	"x13": true,
	"x14": true,
	"x15": true,
	"x16": true,
	"x17": true,
	"x18": true,
	"x19": true,
	"x20": true,
	"x21": true,
	"x22": true,
	"x23": true,
	"x24": true,
	"x25": true,
	"x26": true,
	"x27": true,
	"x28": true,
	"x29": true,
	"x30": true,
	"x31": true,
}
var abiToReg = map[string]string{
	"zero": "x0",
	"ra":   "x1",
	"sp":   "x2",
	"gp":   "x3",
	"tp":   "x4",
	"t0":   "x5",
	"t1":   "x6",
	"t2":   "x7",
	"s0":   "x8",
	"fp":   "x8",
	"s1":   "x9",
	"a0":   "x10",
	"a1":   "x11",
	"a2":   "x12",
	"a3":   "x13",
	"a4":   "x14",
	"a5":   "x15",
	"a6":   "x16",
	"a7":   "x17",
	"s2":   "x18",
	"s3":   "x19",
	"s4":   "x20",
	"s5":   "x21",
	"s6":   "x22",
	"s7":   "x23",
	"s8":   "x24",
	"s9":   "x25",
	"s10":  "x26",
	"s11":  "x27",
	"t3":   "x28",
	"t4":   "x29",
	"t5":   "x30",
	"t6":   "x31",
}

func isRegister(s string) (bool, string) {
	if baseRegs[s] {
		return true, s
	} else if abiToReg[s] != "" {
		return true, abiToReg[s]
	}
	return false, ""
}
