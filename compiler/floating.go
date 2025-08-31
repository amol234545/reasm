package compiler

func fdiv(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = %s / %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}

/** Fused */
func fmadd(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = %s * %s + %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]), CompileRegister(command.Arguments[3]))
}
func fmsub(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = %s * %s - %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]), CompileRegister(command.Arguments[3]))
}
func fnmadd(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = -%s * %s + %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]), CompileRegister(command.Arguments[3]))
}
func fnmsub(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = -%s * %s - %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]), CompileRegister(command.Arguments[3]))
}

/** Special 👀 */
func fsqrt(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = sqrt(%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func fsgnj(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = abs(%s) * sgn(%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func fsgnjn(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = abs(%s) * -sgn(%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func fsgnjx(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = %s * sgn(%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}

/* Min Max */
func fmin(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = min(%s, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func fmax(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = max(%s, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}

/** Conversion */
func fcvt(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func feq(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = if %s == %s then 1 else 0\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func flt(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = if %s < %s then 1 else 0\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}
func flte(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = if %s <= %s then 1 else 0\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[2]))
}

/** Other */
func fcvtint(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = floor(%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func fclass(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = fclass(%s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
