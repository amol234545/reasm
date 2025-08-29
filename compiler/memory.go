package compiler

/** Save Memory */
func sw(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "buffer.writei32(memory, %s, %s)\n", CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[0]))
}
func sh(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "buffer.writei16(memory, %s, %s)\n", CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[0]))
}
func sb(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "buffer.writei8(memory, %s, %s)\n", CompileRegister(command.Arguments[1]), CompileRegister(command.Arguments[0]))
}

/** Load Memory */
func li(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func lw(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = buffer.readi32(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func lui(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func lb(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = buffer.readi8(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
func lbu(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = buffer.readu8(memory, %s)\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}
