package compiler

/* Math */
func add(w *OutputWriter, command AssemblyCommand) { /* add & addi instructions */
	WriteIndentedString(w, "%s = %s + %s\n", CompileRegister(w, command.Arguments[0]), CompileRegister(w, command.Arguments[1]), CompileRegister(w, command.Arguments[2]))
}
func sub(w *OutputWriter, command AssemblyCommand) { /* sub & subi instructions */
	WriteIndentedString(w, "%s = %s - %s\n", CompileRegister(w, command.Arguments[0]), CompileRegister(w, command.Arguments[1]), CompileRegister(w, command.Arguments[2]))
}
func mul(w *OutputWriter, command AssemblyCommand) { /* mul & muli instructions */
	WriteIndentedString(w, "%s = %s * %s\n", CompileRegister(w, command.Arguments[0]), CompileRegister(w, command.Arguments[1]), CompileRegister(w, command.Arguments[2]))
}
func div(w *OutputWriter, command AssemblyCommand) { /* div & divi instructions */
	WriteIndentedString(w, "%s = idiv_trunc(%s, %s)\n", CompileRegister(w, command.Arguments[0]), CompileRegister(w, command.Arguments[1]), CompileRegister(w, command.Arguments[2]))
}
func rem(w *OutputWriter, command AssemblyCommand) { /* rem & remi instructions */
	WriteIndentedString(w, "%s = %s %% %s\n", CompileRegister(w, command.Arguments[0]), CompileRegister(w, command.Arguments[1]), CompileRegister(w, command.Arguments[2]))
}
func neg(w *OutputWriter, command AssemblyCommand) { /* neg & negi instructions */
	WriteIndentedString(w, "%s = -%s\n", CompileRegister(w, command.Arguments[0]), CompileRegister(w, command.Arguments[1]))
}

/** Math Descendants */
func mulh(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "%s = band(lshift(%s, %s), 0xFFFFFFFF)\n", CompileRegister(w, command.Arguments[0]), CompileRegister(w, command.Arguments[1]), CompileRegister(w, command.Arguments[2]))
}
