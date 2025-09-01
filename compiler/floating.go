package compiler

/** Memory */
func fld(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = readf64(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func flw(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = readf32(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func fsd(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "writef64(memory, %s, %s)\n", CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[0]))
}
func fsw(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "writef32(memory, %s, %s)\n", CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[0]))
}

/** Fused */
func fmadd(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = %s * %s + %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]), CompileRegister(command.Arguments[3]))
}
func fmsub(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = %s * %s - (%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]), CompileRegister(command.Arguments[3]))
}
func fnmadd(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = -(%s) * %s + %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]), CompileRegister(command.Arguments[3]))
}
func fnmsub(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = -(%s) * %s - (%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]), CompileRegister(command.Arguments[3]))
}

/** Other math */
func fsqrt(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = sqrt(%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func fmin(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = min(%s, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func fmax(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = max(%s, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}

/** Comparators */
func feq(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = if %s == %s then 1 else 0\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func flt(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = if %s < %s then 1 else 0\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func fle(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = if %s <= %s then 1 else 0\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}

/** Conversion */
func fcvt_d_s(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func fmv_w_x(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = int_to_float(%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func fmv_x_w(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers[\"%s\"] = float_to_int(%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
