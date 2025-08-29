package compiler

func slt(w *OutputWriter, command AssemblyCommand) { /* sltu & sltui instructions */
	WriteIndentedString(w, "registers.%s = if (%s < %s) then 1 else 0\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func srai(w *OutputWriter, command AssemblyCommand) { /* srai & srari instructions */
	WriteIndentedString(w, "registers.%s = bit32.arshift(%s, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
