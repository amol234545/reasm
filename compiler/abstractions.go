package compiler

func ret(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "if registers.ra ~= 0 then\n")
	w.Depth++
	//WriteIndentedString(w, "print('ret', RETURN)\n")
	WriteIndentedString(w, "PC = registers.ra\n")
	WriteIndentedString(w, "registers.ra = 0\n")
	WriteIndentedString(w, "continue\n")
	w.Depth--
	WriteIndentedString(w, "else\n")
	w.Depth++
	WriteIndentedString(w, "PC = 0\n")
	w.Depth--
	WriteIndentedString(w, "end\n")
}
func call(w *OutputWriter, command AssemblyCommand) {
	var function = command.Arguments[0].Source

	/* the actual jump */
	WriteIndentedString(w, "if functions[\"%s\"] then\n", function)
	w.Depth++
	WriteIndentedString(w, "functions[\"%s\"]() -- invoke provided function %s\n", function, function)
	WriteIndentedString(w, "PC = %d -- since we are cutting early\n", w.MaxPC)
	w.Depth--
	WriteIndentedString(w, "else\n")
	w.Depth++
	JumpTo(w, function, true)
	w.Depth--
	WriteIndentedString(w, "end\n")

	/* cut the jump */
	CutAndLink(w)
}
func move(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "registers.%s = %s\n", command.Arguments[0].Source, CompileRegister(command.Arguments[1]))
}

/* unimplemented */
func auipc(w *OutputWriter, command AssemblyCommand) {
	panic("AUIPC cannot be used.")
}
func jalr(w *OutputWriter, command AssemblyCommand) {
	panic("JALR cannot be used.")
}
func ebreak(w *OutputWriter, command AssemblyCommand) {
	panic("EBREAK cannot be used (yet).")
}
func ecall(w *OutputWriter, command AssemblyCommand) {
	panic("ECALL cannot be used (yet).")
}
func fence(w *OutputWriter, command AssemblyCommand) {
	panic("FENCE cannot be used.")
}
