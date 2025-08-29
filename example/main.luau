-- Compiled from RISC-V assembly.
--- API
local mem = 2048 -- 2KB of RAM
local memory = buffer.create(mem) -- our memory!
local data = {} -- pointers in memory to static data, ex: strings
local registers = {
    ["zero"] = 0,    ["x0"]  = 0,     ["ra"]   = 0,    ["x1"]  = 0,
    ["sp"]   = mem,  ["x2"]  = 0,     ["gp"]   = 0,    ["x3"]  = 0,
    ["tp"]   = 0,    ["x4"]  = 0,     ["t0"]   = 0,    ["x5"]  = 0,
    ["t1"]   = 0,    ["x6"]  = 0,     ["t2"]   = 0,    ["x7"]  = 0,

    ["s0"]   = 0,    ["fp"]  = 0,     ["x8"]   = 0,    ["s1"]  = 0,
    ["x9"]   = 0,    ["a0"]  = 0,     ["x10"]  = 0,    ["a1"]  = 0,

    ["x11"]  = 0,    ["a2"]  = 0,     ["x12"]  = 0,    ["a3"]  = 0,
    ["x13"]  = 0,    ["a4"]  = 0,     ["x14"]  = 0,    ["a5"]  = 0,

    ["x15"]  = 0,    ["a6"]  = 0,     ["x16"]  = 0,    ["a7"]  = 0,
    ["x17"]  = 0,    ["s2"]  = 0,     ["x18"]  = 0,    ["s3"]  = 0,

    ["x19"]  = 0,    ["s4"]  = 0,     ["x20"]  = 0,    ["s5"]  = 0,
    ["x21"]  = 0,    ["s6"]  = 0,     ["x22"]  = 0,    ["s7"]  = 0,

    ["x23"]  = 0,    ["s8"]  = 0,     ["x24"]  = 0,    ["s9"]  = 0,
    ["x25"]  = 0,    ["s10"] = 0,     ["x26"]  = 0,    ["s11"] = 0,

    ["x27"]  = 0,    ["t3"]  = 0,     ["x28"]  = 0,    ["t4"]  = 0,
    ["x29"]  = 0,    ["t5"]  = 0,     ["x30"]  = 0,    ["t6"]  = 0,
    ["x31"]  = 0
}
local functions = {
    ["print"] = function()
        -- read string
        local pointer = registers["a0"]
        local str = ""
        local byte = -1
        while byte ~= 0 do
            byte = buffer.readbits(memory, pointer * 8, 8)  -- read 8 bits (1 byte)
            str = str .. string.char(byte)
            pointer = pointer + 1
        end
        -- print
        print(str)
    end,
}

--- Variables
local PC = "main" -- where the next iteration shall goto
local RETURN = nil -- a return address for the GOTO
local init = true -- becomes false when the buffer is poluted with static data

--- Utility
local function hi(addr)
    return bit32.lshift(bit32.rshift(addr, 12), 12)
end
local function lo(addr)
    return bit32.band(addr, 0xFFF)
end

---- Auto generated code starts here
while PC do
	-- ASM ATTRIBUTE: .attribute	4, 16
	-- ASM ATTRIBUTE: .attribute	5, "rv32i2p1_m2p0_a2p1_c2p0_zmmul1p0_zaamo1p0_zalrsc1p0"
	-- ASM ATTRIBUTE: .file	"main.c"
	-- ASM ATTRIBUTE: .text
	-- ASM ATTRIBUTE: .globl	printtwice
	-- ASM ATTRIBUTE: .p2align	1
	-- ASM ATTRIBUTE: .type	printtwice,@function
	if PC == "printtwice" and not init then -- printtwice (runtime) 
		-- addi ([{0 false sp } {0 false sp } {0 true -16 }])
		registers["sp"] = registers["sp"] + -16
		-- sw ([{0 false ra } {12 true sp }])
		buffer.writei32(memory, registers["sp"]+12, registers["ra"])
		-- sw ([{0 true s0 } {8 true sp }])
		buffer.writei32(memory, registers["sp"]+8, registers["s0"])
		-- addi ([{0 true s0 } {0 false sp } {0 true 16 }])
		registers["s0"] = registers["sp"] + 16
		-- sw ([{0 true a0 } {-12 true s0 }])
		buffer.writei32(memory, registers["s0"]+-12, registers["a0"])
		-- li ([{0 true a0 } {0 true 0 }])
		registers["a0"] = 0
		-- sw ([{0 true a0 } {-16 true s0 }])
		buffer.writei32(memory, registers["s0"]+-16, registers["a0"])
		-- j ([{0 true .LBB0_1 }])
		RETURN = "printtwice_end"
		PC = ".LBB0_1"
		continue
	end -- printtwice (printtwice)
	if PC == ".LBB0_1" and not init then -- .LBB0_1 (runtime) 
		-- lw ([{0 true a1 } {-16 true s0 }])
		registers["a1"] = buffer.readi32(memory, registers["s0"]+-16)
		-- li ([{0 true a0 } {0 true 1 }])
		registers["a0"] = 1
		-- blt ([{0 true a0 } {0 true a1 } {0 true .LBB0_4 }])
		if registers["a0"] < registers["a1"] then
			RETURN = ".LBB0_1_end"
			PC = ".LBB0_4"
			continue
		end
		-- j ([{0 true .LBB0_2 }])
		RETURN = ".LBB0_1_end"
		PC = ".LBB0_2"
		continue
	end -- .LBB0_1 (.LBB0_1)
	if PC == ".LBB0_2" and not init then -- .LBB0_2 (runtime) 
		-- lw ([{0 true a0 } {-12 true s0 }])
		registers["a0"] = buffer.readi32(memory, registers["s0"]+-12)
		-- call ([{0 false print }])
		if functions["print"] then
			functions["print"]() -- invoke provided function print
			PC = ".LBB0_2_end" -- since we are cutting early
		else
			RETURN = ".LBB0_2_end"
			PC = "print"
			continue
		end
	end -- .LBB0_2 (.LBB0_2)
	if PC == ".LBB0_2_end" and not init then -- .LBB0_2 (extended) 
		-- j ([{0 true .LBB0_3 }])
		RETURN = ".LBB0_2_end"
		PC = ".LBB0_3"
		continue
	end -- .LBB0_2 (.LBB0_2)
	if PC == ".LBB0_3" and not init then -- .LBB0_3 (runtime) 
		-- lw ([{0 true a0 } {-16 true s0 }])
		registers["a0"] = buffer.readi32(memory, registers["s0"]+-16)
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1 }])
		registers["a0"] = registers["a0"] + 1
		-- sw ([{0 true a0 } {-16 true s0 }])
		buffer.writei32(memory, registers["s0"]+-16, registers["a0"])
		-- j ([{0 true .LBB0_1 }])
		RETURN = ".LBB0_3_end"
		PC = ".LBB0_1"
		continue
	end -- .LBB0_3 (.LBB0_3)
	if PC == ".LBB0_4" and not init then -- .LBB0_4 (runtime) 
		-- lw ([{0 false ra } {12 true sp }])
		registers["ra"] = buffer.readi32(memory, registers["sp"]+12)
		-- lw ([{0 true s0 } {8 true sp }])
		registers["s0"] = buffer.readi32(memory, registers["sp"]+8)
		-- addi ([{0 false sp } {0 false sp } {0 true 16 }])
		registers["sp"] = registers["sp"] + 16
		-- ret ([])
		PC = RETURN
		RETURN = nil
		continue
	end -- .LBB0_4 (.LBB0_4)
	if PC == ".Lfunc_end0" and not init then -- .Lfunc_end0 (runtime) 
		-- ASM ATTRIBUTE: .globl	main
		-- ASM ATTRIBUTE: .p2align	1
		-- ASM ATTRIBUTE: .type	main,@function
	end -- .Lfunc_end0 (.Lfunc_end0)
	if PC == "main" and not init then -- main (runtime) 
		-- addi ([{0 false sp } {0 false sp } {0 true -16 }])
		registers["sp"] = registers["sp"] + -16
		-- sw ([{0 false ra } {12 true sp }])
		buffer.writei32(memory, registers["sp"]+12, registers["ra"])
		-- sw ([{0 true s0 } {8 true sp }])
		buffer.writei32(memory, registers["sp"]+8, registers["s0"])
		-- addi ([{0 true s0 } {0 false sp } {0 true 16 }])
		registers["s0"] = registers["sp"] + 16
		-- li ([{0 true a0 } {0 true 0 }])
		registers["a0"] = 0
		-- sw ([{0 true a0 } {-16 true s0 }])
		buffer.writei32(memory, registers["s0"]+-16, registers["a0"])
		-- sw ([{0 true a0 } {-12 true s0 }])
		buffer.writei32(memory, registers["s0"]+-12, registers["a0"])
		-- lui ([{0 true a0 } {0 false .L.str hi}])
		registers["a0"] = hi(data["str"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str lo}])
		registers["a0"] = registers["a0"] + lo(data["str"])
		-- call ([{0 false printtwice }])
		if functions["printtwice"] then
			functions["printtwice"]() -- invoke provided function printtwice
			PC = "main_end" -- since we are cutting early
		else
			RETURN = "main_end"
			PC = "printtwice"
			continue
		end
	end -- main (main)
	if PC == "main_end" and not init then -- main (extended) 
		-- lw ([{0 true a0 } {-16 true s0 }])
		registers["a0"] = buffer.readi32(memory, registers["s0"]+-16)
		-- lw ([{0 false ra } {12 true sp }])
		registers["ra"] = buffer.readi32(memory, registers["sp"]+12)
		-- lw ([{0 true s0 } {8 true sp }])
		registers["s0"] = buffer.readi32(memory, registers["sp"]+8)
		-- addi ([{0 false sp } {0 false sp } {0 true 16 }])
		registers["sp"] = registers["sp"] + 16
		-- ret ([])
		PC = RETURN
		RETURN = nil
		continue
	end -- main (main)
	if PC == ".Lfunc_end1" and not init then -- .Lfunc_end1 (runtime) 
		-- ASM ATTRIBUTE: .type	.L.str,@object
		-- ASM ATTRIBUTE: .section	.rodata.str1.1,"aMS",@progbits,1
	end -- .Lfunc_end1 (.Lfunc_end1)
	if init then -- .L.str (initialization)
		buffer.writestring(memory, 0, "hi\0")
		data["str"] = 0 -- represents ^
		-- ASM ATTRIBUTE: .ident	"Homebrew clang version 20.1.8"
		-- ASM ATTRIBUTE: .section	".note.GNU-stack","",@progbits
		-- ASM ATTRIBUTE: .addrsig
		-- ASM ATTRIBUTE: .addrsig_sym printtwice
		-- ASM ATTRIBUTE: .addrsig_sym print
	end -- .L.str (.L.str)
	init = false -- do not initialize again
	-- if no PC, or invalid PC then break (look into alternative implementations in the future) 
	if (not PC) or (PC ~= "printtwice" and PC ~= ".LBB0_1" and PC ~= ".LBB0_2" and PC ~= ".LBB0_3" and PC ~= ".LBB0_4" and PC ~= ".Lfunc_end0" and PC ~= "main" and PC ~= ".Lfunc_end1" and PC ~= ".L.str") then
		break
	end
end
