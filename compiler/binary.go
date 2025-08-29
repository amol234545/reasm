package compiler

/** Binary Shifts */
func sll(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = bit32.band(bit32.lshift(%s, %s), 0xFFFFFFFF)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func srl(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = bit32.band(bit32.rshift(%s, %s), 0xFFFFFFFF)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func sra(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = bit32.band(bit32.arshift(%s, %s), 0xFFFFFFFF)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}

/* Comparision */
func slt(w *OutputWriter, command AssemblyCommand) { /* sltu & sltui instructions */
	WriteIndentedString(w, "registers.%s = if (%s < %s) then 1 else 0\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}

/** Binary Operations */
func and(w *OutputWriter, command AssemblyCommand) { /* and & andi instructions */
	WriteIndentedString(w, "registers.%s = bit32.band(%s, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func xor(w *OutputWriter, command AssemblyCommand) { /* xor & xori instructions */
	WriteIndentedString(w, "registers.%s = bit32.bxor(%s, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func or(w *OutputWriter, command AssemblyCommand) { /* or & ori instructions */
	WriteIndentedString(w, "registers.%s = bit32.bor(%s, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
