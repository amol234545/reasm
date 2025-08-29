package compiler

func ret(w *OutputWriter, command AssemblyCommand) {
	WriteIndentedString(w, "if RETURN then\n")
	w.Depth++
	//WriteIndentedString(w, "print('ret', RETURN)\n")
	WriteIndentedString(w, "PC = RETURN\n")
	WriteIndentedString(w, "RETURN = nil\n")
	WriteIndentedString(w, "continue\n")
	w.Depth--
	WriteIndentedString(w, "else\n")
	w.Depth++
	WriteIndentedString(w, "PC = nil\n")
	w.Depth--
	WriteIndentedString(w, "end\n")
}
func call(w *OutputWriter, command AssemblyCommand) {
	var function = command.Arguments[0].Source

	/* the actual jump */
	WriteIndentedString(w, "if functions[\"%s\"] then\n", function)
	w.Depth++
	WriteIndentedString(w, "functions[\"%s\"]() -- invoke provided function %s\n", function, function)
	WriteIndentedString(w, "PC = \"%s_end\" -- since we are cutting early\n", w.CurrentLabel)
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
