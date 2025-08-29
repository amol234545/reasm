package compiler

/** Math */
func add(w *OutputWriter, command AssemblyCommand) { /* add & addi instructions */
	WriteIndentedString(w, "registers.%s = %s + %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func sub(w *OutputWriter, command AssemblyCommand) { /* sub & subi instructions */
	WriteIndentedString(w, "registers.%s = %s - %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func mul(w *OutputWriter, command AssemblyCommand) { /* mul & muli instructions */
	WriteIndentedString(w, "registers.%s = %s * %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func div(w *OutputWriter, command AssemblyCommand) { /* div & divi instructions */
	WriteIndentedString(w, "registers.%s = %s // %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func rem(w *OutputWriter, command AssemblyCommand) { /* rem & remi instructions */
	WriteIndentedString(w, "registers.%s = %s %% %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}

/*** Math Descendants */
func mulh(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = bit32.band(bit32.lshift(%s, %s), 0xFFFFFFFF)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
