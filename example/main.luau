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
        local byte
        repeat
            byte = buffer.readbits(memory, pointer * 8, 8)
            if byte == 0 then break end
            str = str .. string.char(byte)
            pointer = pointer + 1
            if pointer >= mem then error("Buffer overflow in printf string read") end
        until false

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
local function idiv_trunc(a, b)
  if b == 0 then error("division by zero") end
  local q = math.modf(a / b) -- truncated toward zero
  return bit32.band(q, 0xFFFFFFFF) -- keep 32-bit wrap semantics if desired
end

local function hi(addr)
    return bit32.lshift(bit32.rshift(addr, 12), 12)
end
local function lo(addr)
    return bit32.band(addr, 0xFFF)
end

---- Auto generated code starts here
while PC do
	-- ASM ATTRIBUTE: .attribute	4, 16
	-- ASM ATTRIBUTE: .attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	-- ASM ATTRIBUTE: .file	"main.c"
	-- ASM ATTRIBUTE: .text
	-- ASM ATTRIBUTE: .globl	factorial
	-- ASM ATTRIBUTE: .p2align	2
	-- ASM ATTRIBUTE: .type	factorial,@function
	if PC == "factorial" and not init then -- factorial (runtime) 
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
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- blt ([{0 true a0 } {0 true a1 } {0 true .LBB0_2 }])
		if registers.a0 < registers.a1 then
			PC = ".LBB0_2"
			continue
		end
		-- j ([{0 true .LBB0_1 }])
		PC = ".LBB0_1"
		continue
	end -- factorial (factorial)
	if PC == ".LBB0_1" and not init then -- .LBB0_1 (runtime) 
		-- li ([{0 true a0 } {0 true 10 }])
		registers.a0 = 10
		-- sw ([{0 true a0 } {-12 true s0 }])
		buffer.writei32(memory, registers.s0+-12, registers.a0)
		-- j ([{0 true .LBB0_9 }])
		PC = ".LBB0_9"
		continue
	end -- .LBB0_1 (.LBB0_1)
	if PC == ".LBB0_2" and not init then -- .LBB0_2 (runtime) 
		-- li ([{0 true a0 } {0 true 1 }])
		registers.a0 = 1
		-- sw ([{0 true a0 } {-20 true s0 }])
		buffer.writei32(memory, registers.s0+-20, registers.a0)
		-- lw ([{0 true a0 } {-16 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-16)
		-- sw ([{0 true a0 } {-24 true s0 }])
		buffer.writei32(memory, registers.s0+-24, registers.a0)
		-- j ([{0 true .LBB0_3 }])
		PC = ".LBB0_3"
		continue
	end -- .LBB0_2 (.LBB0_2)
	if PC == ".LBB0_3" and not init then -- .LBB0_3 (runtime) 
		-- lw ([{0 true a1 } {-24 true s0 }])
		registers.a1 = buffer.readi32(memory, registers.s0+-24)
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- bge ([{0 true a0 } {0 true a1 } {0 true .LBB0_8 }])
		if registers.a0 >= registers.a1 then
			PC = ".LBB0_8"
			continue
		end
		-- j ([{0 true .LBB0_4 }])
		PC = ".LBB0_4"
		continue
	end -- .LBB0_3 (.LBB0_3)
	if PC == ".LBB0_4" and not init then -- .LBB0_4 (runtime) 
		-- lw ([{0 true a1 } {-24 true s0 }])
		registers.a1 = buffer.readi32(memory, registers.s0+-24)
		-- lw ([{0 true a0 } {-20 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-20)
		-- mul ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 * registers.a1
		-- sw ([{0 true a0 } {-20 true s0 }])
		buffer.writei32(memory, registers.s0+-20, registers.a0)
		-- lw ([{0 true a0 } {-20 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-20)
		-- srli ([{0 true a1 } {0 true a0 } {0 true 31 }])
		registers.a1 = bit32.band(bit32.rshift(registers.a0, 31), 0xFFFFFFFF)
		-- add ([{0 true a1 } {0 true a0 } {0 true a1 }])
		registers.a1 = registers.a0 + registers.a1
		-- andi ([{0 true a1 } {0 true a1 } {0 true -2 }])
		registers.a1 = bit32.band(registers.a1, -2)
		-- sub ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 - registers.a1
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
		-- lw ([{0 true a1 } {-24 true s0 }])
		registers.a1 = buffer.readi32(memory, registers.s0+-24)
		-- lw ([{0 true a2 } {-20 true s0 }])
		registers.a2 = buffer.readi32(memory, registers.s0+-20)
		-- lui ([{0 true a0 } {0 false .L.str hi}])
		registers.a0 = hi(data["str"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str lo}])
		registers.a0 = registers.a0 + lo(data["str"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]() -- invoke provided function printf
			PC = ".LBB0_5_end" -- since we are cutting early
		else
			RETURN = ".LBB0_5_end"
			PC = "printf"
			continue
		end
	end -- .LBB0_5 (.LBB0_5)
	if PC == ".LBB0_5_end" and not init then -- .LBB0_5 (extended) 
		-- j ([{0 true .LBB0_7 }])
		PC = ".LBB0_7"
		continue
	end -- .LBB0_5_end (.LBB0_5_end)
	if PC == ".LBB0_6" and not init then -- .LBB0_6 (runtime) 
		-- lw ([{0 true a1 } {-24 true s0 }])
		registers.a1 = buffer.readi32(memory, registers.s0+-24)
		-- lw ([{0 true a2 } {-20 true s0 }])
		registers.a2 = buffer.readi32(memory, registers.s0+-20)
		-- lui ([{0 true a0 } {0 true .L.str.1 hi}])
		registers.a0 = hi(data["str.1"])
		-- addi ([{0 true a0 } {0 true a0 } {0 true .L.str.1 lo}])
		registers.a0 = registers.a0 + lo(data["str.1"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]() -- invoke provided function printf
			PC = ".LBB0_6_end" -- since we are cutting early
		else
			RETURN = ".LBB0_6_end"
			PC = "printf"
			continue
		end
	end -- .LBB0_6 (.LBB0_6)
	if PC == ".LBB0_6_end" and not init then -- .LBB0_6 (extended) 
		-- j ([{0 true .LBB0_7 }])
		PC = ".LBB0_7"
		continue
	end -- .LBB0_6_end (.LBB0_6_end)
	if PC == ".LBB0_7" and not init then -- .LBB0_7 (runtime) 
		-- lw ([{0 true a0 } {-24 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-24)
		-- addi ([{0 true a0 } {0 true a0 } {0 true -1 }])
		registers.a0 = registers.a0 + -1
		-- sw ([{0 true a0 } {-24 true s0 }])
		buffer.writei32(memory, registers.s0+-24, registers.a0)
		-- j ([{0 true .LBB0_3 }])
		PC = ".LBB0_3"
		continue
	end -- .LBB0_7 (.LBB0_7)
	if PC == ".LBB0_8" and not init then -- .LBB0_8 (runtime) 
		-- lw ([{0 true a0 } {-20 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-20)
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
		-- ASM ATTRIBUTE: .p2align	2
		-- ASM ATTRIBUTE: .type	main,@function
	end -- .Lfunc_end0 (.Lfunc_end0)
	if PC == "main" and not init then -- main (runtime) 
		-- addi ([{0 false sp } {0 false sp } {0 true -48 }])
		registers.sp = registers.sp + -48
		-- sw ([{0 false ra } {44 true sp }])
		buffer.writei32(memory, registers.sp+44, registers.ra)
		-- sw ([{0 true s0 } {40 true sp }])
		buffer.writei32(memory, registers.sp+40, registers.s0)
		-- addi ([{0 true s0 } {0 false sp } {0 true 48 }])
		registers.s0 = registers.sp + 48
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {-12 true s0 }])
		buffer.writei32(memory, registers.s0+-12, registers.a0)
		-- li ([{0 true a1 } {0 true 6 }])
		registers.a1 = 6
		-- sw ([{0 true a1 } {-16 true s0 }])
		buffer.writei32(memory, registers.s0+-16, registers.a1)
		-- sw ([{0 true a0 } {-20 true s0 }])
		buffer.writei32(memory, registers.s0+-20, registers.a0)
		-- li ([{0 true a1 } {0 true -5 }])
		registers.a1 = -5
		-- sw ([{0 true a1 } {-24 true s0 }])
		buffer.writei32(memory, registers.s0+-24, registers.a1)
		-- li ([{0 true a1 } {0 true 4 }])
		registers.a1 = 4
		-- sw ([{0 true a1 } {-28 true s0 }])
		buffer.writei32(memory, registers.s0+-28, registers.a1)
		-- li ([{0 true a1 } {0 true 3 }])
		registers.a1 = 3
		-- sw ([{0 true a1 } {-32 true s0 }])
		buffer.writei32(memory, registers.s0+-32, registers.a1)
		-- li ([{0 true a1 } {0 true 5 }])
		registers.a1 = 5
		-- sw ([{0 true a1 } {-36 true s0 }])
		buffer.writei32(memory, registers.s0+-36, registers.a1)
		-- sw ([{0 true a0 } {-40 true s0 }])
		buffer.writei32(memory, registers.s0+-40, registers.a0)
		-- j ([{0 true .LBB1_1 }])
		PC = ".LBB1_1"
		continue
	end -- main (main)
	if PC == ".LBB1_1" and not init then -- .LBB1_1 (runtime) 
		-- lw ([{0 true a0 } {-40 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-40)
		-- lw ([{0 true a1 } {-36 true s0 }])
		registers.a1 = buffer.readi32(memory, registers.s0+-36)
		-- bge ([{0 true a0 } {0 true a1 } {0 true .LBB1_4 }])
		if registers.a0 >= registers.a1 then
			PC = ".LBB1_4"
			continue
		end
		-- j ([{0 true .LBB1_2 }])
		PC = ".LBB1_2"
		continue
	end -- .LBB1_1 (.LBB1_1)
	if PC == ".LBB1_2" and not init then -- .LBB1_2 (runtime) 
		-- lw ([{0 true a0 } {-40 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-40)
		-- slli ([{0 true a1 } {0 true a0 } {0 true 2 }])
		registers.a1 = bit32.band(bit32.lshift(registers.a0, 2), 0xFFFFFFFF)
		-- addi ([{0 true a0 } {0 true s0 } {0 true -32 }])
		registers.a0 = registers.s0 + -32
		-- sw ([{0 true a0 } {-44 true s0 }])
		buffer.writei32(memory, registers.s0+-44, registers.a0)
		-- add ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 + registers.a1
		-- lw ([{0 true a1 } {0 true a0 }])
		registers.a1 = buffer.readi32(memory, registers.a0)
		-- lui ([{0 true a0 } {0 true .L.str.2 hi}])
		registers.a0 = hi(data["str.2"])
		-- addi ([{0 true a0 } {0 true a0 } {0 true .L.str.2 lo}])
		registers.a0 = registers.a0 + lo(data["str.2"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]() -- invoke provided function printf
			PC = ".LBB1_2_end" -- since we are cutting early
		else
			RETURN = ".LBB1_2_end"
			PC = "printf"
			continue
		end
	end -- .LBB1_2 (.LBB1_2)
	if PC == ".LBB1_2_end" and not init then -- .LBB1_2 (extended) 
		-- lw ([{0 true a0 } {-44 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-44)
		-- lw ([{0 true a1 } {-40 true s0 }])
		registers.a1 = buffer.readi32(memory, registers.s0+-40)
		-- slli ([{0 true a1 } {0 true a1 } {0 true 2 }])
		registers.a1 = bit32.band(bit32.lshift(registers.a1, 2), 0xFFFFFFFF)
		-- add ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 + registers.a1
		-- lw ([{0 true a0 } {0 true a0 }])
		registers.a0 = buffer.readi32(memory, registers.a0)
		-- call ([{0 false factorial }])
		if functions["factorial"] then
			functions["factorial"]() -- invoke provided function factorial
			PC = ".LBB1_2_end_end" -- since we are cutting early
		else
			RETURN = ".LBB1_2_end_end"
			PC = "factorial"
			continue
		end
	end -- .LBB1_2_end (.LBB1_2_end)
	if PC == ".LBB1_2_end_end" and not init then -- .LBB1_2_end (extended) 
		-- lui ([{0 true a0 } {0 true .L.str.3 hi}])
		registers.a0 = hi(data["str.3"])
		-- addi ([{0 true a0 } {0 true a0 } {0 true .L.str.3 lo}])
		registers.a0 = registers.a0 + lo(data["str.3"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]() -- invoke provided function printf
			PC = ".LBB1_2_end_end_end" -- since we are cutting early
		else
			RETURN = ".LBB1_2_end_end_end"
			PC = "printf"
			continue
		end
	end -- .LBB1_2_end_end (.LBB1_2_end_end)
	if PC == ".LBB1_2_end_end_end" and not init then -- .LBB1_2_end_end (extended) 
		-- j ([{0 true .LBB1_3 }])
		PC = ".LBB1_3"
		continue
	end -- .LBB1_2_end_end_end (.LBB1_2_end_end_end)
	if PC == ".LBB1_3" and not init then -- .LBB1_3 (runtime) 
		-- lw ([{0 true a0 } {-40 true s0 }])
		registers.a0 = buffer.readi32(memory, registers.s0+-40)
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1 }])
		registers.a0 = registers.a0 + 1
		-- sw ([{0 true a0 } {-40 true s0 }])
		buffer.writei32(memory, registers.s0+-40, registers.a0)
		-- j ([{0 true .LBB1_1 }])
		PC = ".LBB1_1"
		continue
	end -- .LBB1_3 (.LBB1_3)
	if PC == ".LBB1_4" and not init then -- .LBB1_4 (runtime) 
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- lw ([{0 false ra } {44 true sp }])
		registers.ra = buffer.readi32(memory, registers.sp+44)
		-- lw ([{0 true s0 } {40 true sp }])
		registers.s0 = buffer.readi32(memory, registers.sp+40)
		-- addi ([{0 false sp } {0 false sp } {0 true 48 }])
		registers.sp = registers.sp + 48
		-- ret ([])
		if RETURN then
			PC = RETURN
			RETURN = nil
			continue
		else
			PC = nil
		end
	end -- .LBB1_4 (.LBB1_4)
	if PC == ".Lfunc_end1" and not init then -- .Lfunc_end1 (runtime) 
		-- ASM ATTRIBUTE: .type	.L.str,@object
		-- ASM ATTRIBUTE: .section	.rodata.str1.1,"aMS",@progbits,1
	end -- .Lfunc_end1 (.Lfunc_end1)
	if init then -- .L.str (initialization)
		buffer.writestring(memory, 0, "%d! = %d (even)\0")
		data["str"] = 0 -- represents ^
		-- ASM ATTRIBUTE: .type	.L.str.1,@object
	end -- .L.str (.L.str)
	if init then -- .L.str.1 (initialization)
		buffer.writestring(memory, 16, "%d! = %d (odd)\0")
		data["str.1"] = 16 -- represents ^
		-- ASM ATTRIBUTE: .type	.L__const.main.numbers,@object
		-- ASM ATTRIBUTE: .section	.rodata,"a",@progbits
		-- ASM ATTRIBUTE: .p2align	2, 0x0
	end -- .L.str.1 (.L.str.1)
	if PC == ".L__const.main.numbers" and not init then -- .L__const.main.numbers (runtime) 
		-- ASM ATTRIBUTE: .word	3
		-- ASM ATTRIBUTE: .word	4
		-- ASM ATTRIBUTE: .word	4294967291
		-- ASM ATTRIBUTE: .word	0
		-- ASM ATTRIBUTE: .word	6
		-- ASM ATTRIBUTE: .type	.L.str.2,@object
		-- ASM ATTRIBUTE: .section	.rodata.str1.1,"aMS",@progbits,1
	end -- .L__const.main.numbers (.L__const.main.numbers)
	if init then -- .L.str.2 (initialization)
		buffer.writestring(memory, 31, "Computing factorial(%d)\0")
		data["str.2"] = 31 -- represents ^
		-- ASM ATTRIBUTE: .type	.L.str.3,@object
	end -- .L.str.2 (.L.str.2)
	if init then -- .L.str.3 (initialization)
		buffer.writestring(memory, 55, "----\0")
		data["str.3"] = 55 -- represents ^
		-- ASM ATTRIBUTE: .ident	"Homebrew clang version 20.1.8"
		-- ASM ATTRIBUTE: .section	".note.GNU-stack","",@progbits
		-- ASM ATTRIBUTE: .addrsig
		-- ASM ATTRIBUTE: .addrsig_sym factorial
		-- ASM ATTRIBUTE: .addrsig_sym printf
	end -- .L.str.3 (.L.str.3)
	init = false -- do not initialize again
	-- if no PC, or invalid PC then break (look into alternative implementations in the future) 
	if (not PC) or (PC ~= "factorial" and PC ~= ".LBB0_1" and PC ~= ".LBB0_2" and PC ~= ".LBB0_3" and PC ~= ".LBB0_4" and PC ~= ".LBB0_5" and PC ~= ".LBB0_5_end" and PC ~= ".LBB0_6" and PC ~= ".LBB0_6_end" and PC ~= ".LBB0_7" and PC ~= ".LBB0_8" and PC ~= ".LBB0_9" and PC ~= ".Lfunc_end0" and PC ~= "main" and PC ~= ".LBB1_1" and PC ~= ".LBB1_2" and PC ~= ".LBB1_2_end" and PC ~= ".LBB1_2_end_end" and PC ~= ".LBB1_2_end_end_end" and PC ~= ".LBB1_3" and PC ~= ".LBB1_4" and PC ~= ".Lfunc_end1" and PC ~= ".L.str" and PC ~= ".L.str.1" and PC ~= ".L__const.main.numbers" and PC ~= ".L.str.2" and PC ~= ".L.str.3") then
		if PC then print("Ended execution due to missing label: " .. PC) end
		break
	end
end
