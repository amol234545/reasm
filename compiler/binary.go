package compiler

/** Binary Shifts */
func slli(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = bit32.band(bit32.lshift(%s, %s), 0xFFFFFFFF)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func srli(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = bit32.band(bit32.rshift(%s, %s), 0xFFFFFFFF)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}

/** Binary Operations */
func and(w *OutputWriter, command AssemblyCommand) { /* and & andi instructions */
	WriteIndentedString(w, "registers.%s = bit32.band(%s, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
