package compiler

/** Memory */
func flw(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = readf32(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func fsd(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "writef64(memory, %s, %s)\n", CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[0]))
}

/** Math */
func fadd_s(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = %s + %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}

/** Conversion */
func fcvt_d_s(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func fmv_w_x(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = int_to_float(%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
