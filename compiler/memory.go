package compiler

/** Save Memory */
func sw(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "writei32(memory, %s, %s)\n", CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[0]))
}
func sh(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "writei16(memory, %s, %s)\n", CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[0]))
}
func sb(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "writei8(memory, %s, %s)\n", CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[0]))
}

/*** Floating point */
func fsw(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "writef32(memory, %s, %s)\n", CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[0]))
}
func fsd(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "writef64(memory, %s, %s)\n", CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[0]))
}
func flw(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = readf32(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func fld(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = readf64(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}

/** Load Memory */
func li(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func lw(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = readi32(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func lb(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = readi8(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func lh(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = readi16(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func lhu(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = readu16(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func lbu(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = readu8(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
