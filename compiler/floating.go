package compiler

func flw(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = readf32(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func fsd(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "writef64(memory, %s, %s)\n", CompileRegister(command.Arguments[0]), CompileRegister(command.Arguments[1]))
}

/** Conversion */
func fcvt_d_s(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = float_to_double(%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
