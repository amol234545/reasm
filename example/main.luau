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
    ["printf"] = function()
        -- read string
        local pointer = registers["a0"]
        local str = ""
        local byte = -1
        while byte ~= 0 do
            byte = buffer.readbits(memory, pointer * 8, 8)  -- read 8 bits (1 byte)
            str = str .. string.char(byte)
            pointer = pointer + 1
            if pointer >= mem then error("Buffer overflow in printf string read") end
        end

        -- format string
        --- extract args
        local args = {}
        for key, value in pairs(registers) do
           	if string.match(key, "^a%d+$") then
          		local index = tonumber(string.match(key, "%d+"))
          		args[index] = value
           	end
        end
        str = string.format(str, unpack(args))

        -- print
        print(str)
    end
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
	-- ASM ATTRIBUTE: .globl	is_prime
	-- ASM ATTRIBUTE: .p2align	1
	-- ASM ATTRIBUTE: .type	is_prime,@function
	if PC == "is_prime" and not init then -- is_prime (runtime) 
		-- addi ([{0 false sp } {0 false sp } {0 true -32 }])
		registers.sp = registers.sp + -32
		-- sw ([{0 false ra } {28 true sp }])
		buffer.writei32(memory, registers.sp+28, registers.ra)
		-- sw ([{0 true s0 } {24 true sp }])
		buffer.writei32(memory, registers.sp+24, registers.s0)
		-- addi ([{0 true s0 } {0 false sp } {0 true 32 }])
		registers.s0 = registers.sp + 32
		-- sw ([{0 true a0 } {-16 true s0 }])
		buffer.writei32(memory, registers.s0+-16, registers.a0)
		-- lw ([{0 true a1 } {-16 true s0 }])
		registers.a1 = buffer.readi32(memory, registers.s0+-16)
		-- li ([{0 true a0 } {0 true 1 }])
		registers.a0 = 1
		-- blt ([{0 true a0 } {0 true a1 } {0 true .LBB0_2 }])
		if registers.a0 < registers.a1 then
			PC = ".LBB0_2"
			continue
		end
		-- j ([{0 true .LBB0_1 }])
		PC = ".LBB0_1"
		continue
	end -- is_prime (is_prime)
	if PC == ".LBB0_1" and not init then -- .LBB0_1 (runtime) 
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {-12 true s0 }])
		buffer.writei32(memory, registers.s0+-12, registers.a0)
		-- j ([{0 true .LBB0_9 }])
		PC = ".LBB0_9"
		continue
	end -- .LBB0_1 (.LBB0_1)
	if PC == ".LBB0_2" and not init then -- .LBB0_2 (runtime) 
		-- li ([{0 true a0 } {0 true 2 }])
		registers.a0 = 2
		-- sw ([{0 true a0 } {-20 true s0 }])
		buffer.writei32(memory, registers.s0+-20, registers.a0)
		-- j ([{0 true .LBB0_3 }])
		PC = ".LBB0_3"
		continue
	end -- .LBB0_2 (.LBB0_2)
	if PC == ".LBB0_3" and not init then -- .LBB0_3 (runtime) 
		-- lw ([{0 true a0 } {-20 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-20)
		-- mul ([{0 true a1 } {0 true a0 } {0 true a0 }])
		registers.a1 = registers.a0 * registers.a0
		-- lw ([{0 true a0 } {-16 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-16)
		-- blt ([{0 true a0 } {0 true a1 } {0 true .LBB0_8 }])
		if registers.a0 < registers.a1 then
			PC = ".LBB0_8"
			continue
		end
		-- j ([{0 true .LBB0_4 }])
		PC = ".LBB0_4"
		continue
	end -- .LBB0_3 (.LBB0_3)
	if PC == ".LBB0_4" and not init then -- .LBB0_4 (runtime) 
		-- lw ([{0 true a0 } {-16 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-16)
		-- lw ([{0 true a1 } {-20 true s0 }])
		registers.a1 = buffer.readi32(memory, registers.s0+-20)
		-- rem ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 % registers.a1
		-- bnez ([{0 true a0 } {0 true .LBB0_6 }])
		if registers.a0 ~= 0 then
			PC = ".LBB0_6"
			continue
		end
		-- j ([{0 true .LBB0_5 }])
		PC = ".LBB0_5"
		continue
	end -- .LBB0_4 (.LBB0_4)
	if PC == ".LBB0_5" and not init then -- .LBB0_5 (runtime) 
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {-12 true s0 }])
		buffer.writei32(memory, registers.s0+-12, registers.a0)
		-- j ([{0 true .LBB0_9 }])
		PC = ".LBB0_9"
		continue
	end -- .LBB0_5 (.LBB0_5)
	if PC == ".LBB0_6" and not init then -- .LBB0_6 (runtime) 
		-- j ([{0 true .LBB0_7 }])
		PC = ".LBB0_7"
		continue
	end -- .LBB0_6 (.LBB0_6)
	if PC == ".LBB0_7" and not init then -- .LBB0_7 (runtime) 
		-- lw ([{0 true a0 } {-20 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-20)
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1 }])
		registers.a0 = registers.a0 + 1
		-- sw ([{0 true a0 } {-20 true s0 }])
		buffer.writei32(memory, registers.s0+-20, registers.a0)
		-- j ([{0 true .LBB0_3 }])
		PC = ".LBB0_3"
		continue
	end -- .LBB0_7 (.LBB0_7)
	if PC == ".LBB0_8" and not init then -- .LBB0_8 (runtime) 
		-- li ([{0 true a0 } {0 true 1 }])
		registers.a0 = 1
		-- sw ([{0 true a0 } {-12 true s0 }])
		buffer.writei32(memory, registers.s0+-12, registers.a0)
		-- j ([{0 true .LBB0_9 }])
		PC = ".LBB0_9"
		continue
	end -- .LBB0_8 (.LBB0_8)
	if PC == ".LBB0_9" and not init then -- .LBB0_9 (runtime) 
		-- lw ([{0 true a0 } {-12 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-12)
		-- lw ([{0 false ra } {28 true sp }])
		registers.ra = buffer.readi32(memory, registers.sp+28)
		-- lw ([{0 true s0 } {24 true sp }])
		registers.s0 = buffer.readi32(memory, registers.sp+24)
		-- addi ([{0 false sp } {0 false sp } {0 true 32 }])
		registers.sp = registers.sp + 32
		-- ret ([])
		if RETURN then
			PC = RETURN
			RETURN = nil
			continue
		else
			PC = nil
		end
	end -- .LBB0_9 (.LBB0_9)
	if PC == ".Lfunc_end0" and not init then -- .Lfunc_end0 (runtime) 
		-- ASM ATTRIBUTE: .globl	main
		-- ASM ATTRIBUTE: .p2align	1
		-- ASM ATTRIBUTE: .type	main,@function
	end -- .Lfunc_end0 (.Lfunc_end0)
	if PC == "main" and not init then -- main (runtime) 
		-- addi ([{0 false sp } {0 false sp } {0 true -32 }])
		registers.sp = registers.sp + -32
		-- sw ([{0 false ra } {28 true sp }])
		buffer.writei32(memory, registers.sp+28, registers.ra)
		-- sw ([{0 true s0 } {24 true sp }])
		buffer.writei32(memory, registers.sp+24, registers.s0)
		-- addi ([{0 true s0 } {0 false sp } {0 true 32 }])
		registers.s0 = registers.sp + 32
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {-12 true s0 }])
		buffer.writei32(memory, registers.s0+-12, registers.a0)
		-- li ([{0 true a0 } {0 true 100 }])
		registers.a0 = 100
		-- sw ([{0 true a0 } {-16 true s0 }])
		buffer.writei32(memory, registers.s0+-16, registers.a0)
		-- li ([{0 true a0 } {0 true 1 }])
		registers.a0 = 1
		-- sw ([{0 true a0 } {-20 true s0 }])
		buffer.writei32(memory, registers.s0+-20, registers.a0)
		-- j ([{0 true .LBB1_1 }])
		PC = ".LBB1_1"
		continue
	end -- main (main)
	if PC == ".LBB1_1" and not init then -- .LBB1_1 (runtime) 
		-- lw ([{0 true a1 } {-20 true s0 }])
		registers.a1 = buffer.readi32(memory, registers.s0+-20)
		-- lw ([{0 true a0 } {-16 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-16)
		-- blt ([{0 true a0 } {0 true a1 } {0 true .LBB1_6 }])
		if registers.a0 < registers.a1 then
			PC = ".LBB1_6"
			continue
		end
		-- j ([{0 true .LBB1_2 }])
		PC = ".LBB1_2"
		continue
	end -- .LBB1_1 (.LBB1_1)
	if PC == ".LBB1_2" and not init then -- .LBB1_2 (runtime) 
		-- lw ([{0 true a0 } {-20 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-20)
		-- call ([{0 false is_prime }])
		if functions["is_prime"] then
			functions["is_prime"]() -- invoke provided function is_prime
			PC = ".LBB1_2_end" -- since we are cutting early
		else
			RETURN = ".LBB1_2_end"
			PC = "is_prime"
			continue
		end
	end -- .LBB1_2 (.LBB1_2)
	if PC == ".LBB1_2_end" and not init then -- .LBB1_2 (extended) 
		-- beqz ([{0 true a0 } {0 true .LBB1_4 }])
		if registers.a0 == 0 then
			PC = ".LBB1_4"
			continue
		end
		-- j ([{0 true .LBB1_3 }])
		PC = ".LBB1_3"
		continue
	end -- .LBB1_2 (.LBB1_2)
	if PC == ".LBB1_3" and not init then -- .LBB1_3 (runtime) 
		-- lw ([{0 true a1 } {-20 true s0 }])
		registers.a1 = buffer.readi32(memory, registers.s0+-20)
		-- lui ([{0 true a0 } {0 false .L.str hi}])
		registers.a0 = hi(data["str"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str lo}])
		registers.a0 = registers.a0 + lo(data["str"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]() -- invoke provided function printf
			PC = ".LBB1_3_end" -- since we are cutting early
		else
			RETURN = ".LBB1_3_end"
			PC = "printf"
			continue
		end
	end -- .LBB1_3 (.LBB1_3)
	if PC == ".LBB1_3_end" and not init then -- .LBB1_3 (extended) 
		-- j ([{0 true .LBB1_4 }])
		PC = ".LBB1_4"
		continue
	end -- .LBB1_3 (.LBB1_3)
	if PC == ".LBB1_4" and not init then -- .LBB1_4 (runtime) 
		-- j ([{0 true .LBB1_5 }])
		PC = ".LBB1_5"
		continue
	end -- .LBB1_4 (.LBB1_4)
	if PC == ".LBB1_5" and not init then -- .LBB1_5 (runtime) 
		-- lw ([{0 true a0 } {-20 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-20)
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1 }])
		registers.a0 = registers.a0 + 1
		-- sw ([{0 true a0 } {-20 true s0 }])
		buffer.writei32(memory, registers.s0+-20, registers.a0)
		-- j ([{0 true .LBB1_1 }])
		PC = ".LBB1_1"
		continue
	end -- .LBB1_5 (.LBB1_5)
	if PC == ".LBB1_6" and not init then -- .LBB1_6 (runtime) 
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- lw ([{0 false ra } {28 true sp }])
		registers.ra = buffer.readi32(memory, registers.sp+28)
		-- lw ([{0 true s0 } {24 true sp }])
		registers.s0 = buffer.readi32(memory, registers.sp+24)
		-- addi ([{0 false sp } {0 false sp } {0 true 32 }])
		registers.sp = registers.sp + 32
		-- ret ([])
		if RETURN then
			PC = RETURN
			RETURN = nil
			continue
		else
			PC = nil
		end
	end -- .LBB1_6 (.LBB1_6)
	if PC == ".Lfunc_end1" and not init then -- .Lfunc_end1 (runtime) 
		-- ASM ATTRIBUTE: .type	.L.str,@object
		-- ASM ATTRIBUTE: .section	.rodata.str1.1,"aMS",@progbits,1
	end -- .Lfunc_end1 (.Lfunc_end1)
	if init then -- .L.str (initialization)
		buffer.writestring(memory, 0, "%d\0")
		data["str"] = 0 -- represents ^
		-- ASM ATTRIBUTE: .ident	"Homebrew clang version 20.1.8"
		-- ASM ATTRIBUTE: .section	".note.GNU-stack","",@progbits
		-- ASM ATTRIBUTE: .addrsig
		-- ASM ATTRIBUTE: .addrsig_sym is_prime
		-- ASM ATTRIBUTE: .addrsig_sym printf
	end -- .L.str (.L.str)
	init = false -- do not initialize again
	-- if no PC, or invalid PC then break (look into alternative implementations in the future) 
	if (not PC) or (PC ~= "is_prime" and PC ~= ".LBB0_1" and PC ~= ".LBB0_2" and PC ~= ".LBB0_3" and PC ~= ".LBB0_4" and PC ~= ".LBB0_5" and PC ~= ".LBB0_6" and PC ~= ".LBB0_7" and PC ~= ".LBB0_8" and PC ~= ".LBB0_9" and PC ~= ".Lfunc_end0" and PC ~= "main" and PC ~= ".LBB1_1" and PC ~= ".LBB1_2" and PC ~= ".LBB1_3" and PC ~= ".LBB1_4" and PC ~= ".LBB1_5" and PC ~= ".LBB1_6" and PC ~= ".Lfunc_end1" and PC ~= ".L.str") then
		break
	end
end
