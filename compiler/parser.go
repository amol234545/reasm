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

func Parse(command string) AssemblyCommand {
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
		} else if isRegister(p) { // standalone register
			arg.Register = true
			arg.Offset = 0
		} else if strings.HasPrefix(p, "#") { // Immediate (#10)
			valStr := strings.TrimPrefix(p, "#")
			if val, err := strconv.Atoi(valStr); err == nil {
				arg.Offset = int8(val)
			}
		} else if strings.HasPrefix(p, "$") { // Offset ($4)
			valStr := strings.TrimPrefix(p, "$")
			if val, err := strconv.Atoi(valStr); err == nil {
				arg.Offset = int8(val)
			}
		}

		args = append(args, arg)
	}
	return args
}

var regs = map[string]bool{
	// Integer registers
	"zero": true, "x0": true,
	"ra": true, "x1": true,
	"sp": true, "x2": true,
	"gp": true, "x3": true,
	"tp": true, "x4": true,
	"t0": true, "x5": true,
	"t1": true, "x6": true,
	"t2": true, "x7": true,
	"s0": true, "fp": true, "x8": true,
	"s1": true, "x9": true,
	"a0": true, "x10": true,
	"a1": true, "x11": true,
	"a2": true, "x12": true,
	"a3": true, "x13": true,
	"a4": true, "x14": true,
	"a5": true, "x15": true,
	"a6": true, "x16": true,
	"a7": true, "x17": true,
	"s2": true, "x18": true,
	"s3": true, "x19": true,
	"s4": true, "x20": true,
	"s5": true, "x21": true,
	"s6": true, "x22": true,
	"s7": true, "x23": true,
	"s8": true, "x24": true,
	"s9": true, "x25": true,
	"s10": true, "x26": true,
	"s11": true, "x27": true,
	"t3": true, "x28": true,
	"t4": true, "x29": true,
	"t5": true, "x30": true,
	"t6": true, "x31": true,
}

func isRegister(s string) bool {
	return regs[s]
}
