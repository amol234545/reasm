package compiler

/** Jump */
func jump(w *OutputWriter, command AssemblyCommand) { /* j instructions */
	JumpTo(w, command.Arguments[0].Source, false)
}

/** Branching */
func blt(w *OutputWriter, command AssemblyCommand) { /* blt & blti instructions */
	WriteIndentedString(w, "if %s < %s then\n", CompileRegister(command.Arguments[0]), CompileRegister(command.Arguments[1]))
	w.Depth++
	JumpTo(w, command.Arguments[2].Source, false)
	w.Depth--
	WriteIndentedString(w, "end\n")
}
func bnez(w *OutputWriter, command AssemblyCommand) { /* bnez & bnezi instructions */
	WriteIndentedString(w, "if %s ~= 0 then\n", CompileRegister(command.Arguments[0]))
	w.Depth++
	JumpTo(w, command.Arguments[1].Source, false)
	w.Depth--
	WriteIndentedString(w, "end\n")
}
func bne(w *OutputWriter, command AssemblyCommand) { /* bne & bnei instructions */
	WriteIndentedString(w, "if %s ~= %s then\n", CompileRegister(command.Arguments[0]), CompileRegister(command.Arguments[1]))
	w.Depth++
	JumpTo(w, command.Arguments[2].Source, false)
	w.Depth--
	WriteIndentedString(w, "end\n")
}
func bge(w *OutputWriter, command AssemblyCommand) { /* bge & bgei instructions */
	WriteIndentedString(w, "if %s >= %s then\n", CompileRegister(command.Arguments[0]), CompileRegister(command.Arguments[1]))
	w.Depth++
	JumpTo(w, command.Arguments[2].Source, false)
	w.Depth--
	WriteIndentedString(w, "end\n")
}
func beqz(w *OutputWriter, command AssemblyCommand) { /* beqz & beqi instructions */
	WriteIndentedString(w, "if %s == 0 then\n", CompileRegister(command.Arguments[0]))
	w.Depth++
	JumpTo(w, command.Arguments[1].Source, false)
	w.Depth--
	WriteIndentedString(w, "end\n")
}
func beq(w *OutputWriter, command AssemblyCommand) { /* beq & beqi instructions */
	WriteIndentedString(w, "if %s == %s then\n", CompileRegister(command.Arguments[0]), CompileRegister(command.Arguments[1]))
	w.Depth++
	JumpTo(w, command.Arguments[2].Source, false)
	w.Depth--
	WriteIndentedString(w, "end\n")
}
func bgez(w *OutputWriter, command AssemblyCommand) { /* bgez & bgezi instructions */
	WriteIndentedString(w, "if %s >= 0 then\n", CompileRegister(command.Arguments[0]))
	w.Depth++
	JumpTo(w, command.Arguments[1].Source, false)
	w.Depth--
	WriteIndentedString(w, "end\n")
}
