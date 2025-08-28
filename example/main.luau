-- Compiled from RISC-V assembly.
local memory = buffer.create(2048)
local data = {} -- pointers in memory to static data like strings
local registers = {
    ["zero"] = 0,    ["x0"] = 0,
    ["ra"]   = 0,    ["x1"] = 0,
    ["sp"]   = 2048, ["x2"] = 0,
    ["gp"]   = 0,    ["x3"] = 0,
    ["tp"]   = 0,    ["x4"] = 0,
    ["t0"]   = 0,    ["x5"] = 0,
    ["t1"]   = 0,    ["x6"] = 0,
    ["t2"]   = 0,    ["x7"] = 0,
    ["s0"]   = 0,    ["fp"] = 0,    ["x8"] = 0,
    ["s1"]   = 0,    ["x9"] = 0,
    ["a0"]   = 0,    ["x10"] = 0,
    ["a1"]   = 0,    ["x11"] = 0,
    ["a2"]   = 0,    ["x12"] = 0,
    ["a3"]   = 0,    ["x13"] = 0,
    ["a4"]   = 0,    ["x14"] = 0,
    ["a5"]   = 0,    ["x15"] = 0,
    ["a6"]   = 0,    ["x16"] = 0,
    ["a7"]   = 0,    ["x17"] = 0,
    ["s2"]   = 0,    ["x18"] = 0,
    ["s3"]   = 0,    ["x19"] = 0,
    ["s4"]   = 0,    ["x20"] = 0,
    ["s5"]   = 0,    ["x21"] = 0,
    ["s6"]   = 0,    ["x22"] = 0,
    ["s7"]   = 0,    ["x23"] = 0,
    ["s8"]   = 0,    ["x24"] = 0,
    ["s9"]   = 0,    ["x25"] = 0,
    ["s10"]  = 0,    ["x26"] = 0,
    ["s11"]  = 0,    ["x27"] = 0,
    ["t3"]   = 0,    ["x28"] = 0,
    ["t4"]   = 0,    ["x29"] = 0,
    ["t5"]   = 0,    ["x30"] = 0,
    ["t6"]   = 0,    ["x31"] = 0,
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
local PC = "main"
local init = true -- becomes false when the buffer is poluted with static data

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
	-- ASM ATTRIBUTE: .globl	main
	-- ASM ATTRIBUTE: .p2align	1
	-- ASM ATTRIBUTE: .type	main,@function
	if PC == "main" and not init then -- main (runtime) 
		-- addi ([{0 false sp } {0 false sp } {0 true -48 }])
		registers["sp"] = registers["sp"] + -48
		-- sw ([{0 false ra } {44 true sp }])
		buffer.writei32(memory, registers["sp"]+44, registers["ra"])
		-- sw ([{0 true s0 } {40 true sp }])
		buffer.writei32(memory, registers["sp"]+40, registers["s0"])
		-- addi ([{0 true s0 } {0 false sp } {0 true 48 }])
		registers["s0"] = registers["sp"] + 48
		-- li ([{0 true a0 } {0 true 0 }])
		registers["a0"] = 0
		-- sw ([{0 true a0 } {-12 true s0 }])
		buffer.writei32(memory, registers["s0"]+-12, registers["a0"])
		-- li ([{0 true a1 } {0 true 25 }])
		registers["a1"] = 25
		-- sw ([{0 true a1 } {-16 true s0 }])
		buffer.writei32(memory, registers["s0"]+-16, registers["a1"])
		-- sw ([{0 true a0 } {-28 true s0 }])
		buffer.writei32(memory, registers["s0"]+-28, registers["a0"])
		-- sw ([{0 true a0 } {-32 true s0 }])
		buffer.writei32(memory, registers["s0"]+-32, registers["a0"])
		-- sw ([{0 true a0 } {-36 true s0 }])
		buffer.writei32(memory, registers["s0"]+-36, registers["a0"])
		-- li ([{0 true a1 } {0 true 1 }])
		registers["a1"] = 1
		-- sw ([{0 true a1 } {-40 true s0 }])
		buffer.writei32(memory, registers["s0"]+-40, registers["a1"])
		-- sw ([{0 true a0 } {-20 true s0 }])
		buffer.writei32(memory, registers["s0"]+-20, registers["a0"])
		-- j ([{0 true .LBB0_1 }])
		PC = ".LBB0_1"
	end -- main (main)
	if PC == ".LBB0_1" and not init then -- .LBB0_1 (runtime) 
		-- lw ([{0 true a0 } {-20 true s0 }])
		registers["a0"] = buffer.readi32(memory, registers["s0"]+-20)
		-- lw ([{0 true a1 } {-16 true s0 }])
		registers["a1"] = buffer.readi32(memory, registers["s0"]+-16)
		-- bge ([{0 true a0 } {0 true a1 } {0 true .LBB0_7 }])
		if registers["a0"] >= registers["a1"] then
			PC = ".LBB0_7"
			continue
		end
		-- j ([{0 true .LBB0_2 }])
		PC = ".LBB0_2"
	end -- .LBB0_1 (.LBB0_1)
	if PC == ".LBB0_2" and not init then -- .LBB0_2 (runtime) 
		-- lw ([{0 true a1 } {-20 true s0 }])
		registers["a1"] = buffer.readi32(memory, registers["s0"]+-20)
		-- li ([{0 true a0 } {0 true 1 }])
		registers["a0"] = 1
		-- blt ([{0 true a0 } {0 true a1 } {0 true .LBB0_4 }])
		if registers["a0"] < registers["a1"] then
			PC = ".LBB0_4"
			continue
		end
		-- j ([{0 true .LBB0_3 }])
		PC = ".LBB0_3"
	end -- .LBB0_2 (.LBB0_2)
	if PC == ".LBB0_3" and not init then -- .LBB0_3 (runtime) 
		-- lw ([{0 true a1 } {-20 true s0 }])
		registers["a1"] = buffer.readi32(memory, registers["s0"]+-20)
		-- srai ([{0 true a0 } {0 true a1 } {0 true 31 }])
		registers["a0"] = bit32.arshift(registers["a1"], 31)
		-- sw ([{0 true a1 } {-48 true s0 }])
		buffer.writei32(memory, registers["s0"]+-48, registers["a1"])
		-- sw ([{0 true a0 } {-44 true s0 }])
		buffer.writei32(memory, registers["s0"]+-44, registers["a0"])
		-- j ([{0 true .LBB0_5 }])
		PC = ".LBB0_5"
	end -- .LBB0_3 (.LBB0_3)
	if PC == ".LBB0_4" and not init then -- .LBB0_4 (runtime) 
		-- lw ([{0 true a2 } {-32 true s0 }])
		registers["a2"] = buffer.readi32(memory, registers["s0"]+-32)
		-- lw ([{0 true a0 } {-28 true s0 }])
		registers["a0"] = buffer.readi32(memory, registers["s0"]+-28)
		-- lw ([{0 true a1 } {-40 true s0 }])
		registers["a1"] = buffer.readi32(memory, registers["s0"]+-40)
		-- lw ([{0 true a3 } {-36 true s0 }])
		registers["a3"] = buffer.readi32(memory, registers["s0"]+-36)
		-- add ([{0 true a0 } {0 true a0 } {0 true a3 }])
		registers["a0"] = registers["a0"] + registers["a3"]
		-- add ([{0 true a1 } {0 true a1 } {0 true a2 }])
		registers["a1"] = registers["a1"] + registers["a2"]
		-- sltu ([{0 true a2 } {0 true a1 } {0 true a2 }])
		registers["a2"] = if (registers["a1"] < registers["a2"]) then 1 else 0
		-- add ([{0 true a0 } {0 true a0 } {0 true a2 }])
		registers["a0"] = registers["a0"] + registers["a2"]
		-- sw ([{0 true a1 } {-48 true s0 }])
		buffer.writei32(memory, registers["s0"]+-48, registers["a1"])
		-- sw ([{0 true a0 } {-44 true s0 }])
		buffer.writei32(memory, registers["s0"]+-44, registers["a0"])
		-- lw ([{0 true a0 } {-40 true s0 }])
		registers["a0"] = buffer.readi32(memory, registers["s0"]+-40)
		-- lw ([{0 true a1 } {-36 true s0 }])
		registers["a1"] = buffer.readi32(memory, registers["s0"]+-36)
		-- sw ([{0 true a1 } {-28 true s0 }])
		buffer.writei32(memory, registers["s0"]+-28, registers["a1"])
		-- sw ([{0 true a0 } {-32 true s0 }])
		buffer.writei32(memory, registers["s0"]+-32, registers["a0"])
		-- lw ([{0 true a0 } {-48 true s0 }])
		registers["a0"] = buffer.readi32(memory, registers["s0"]+-48)
		-- lw ([{0 true a1 } {-44 true s0 }])
		registers["a1"] = buffer.readi32(memory, registers["s0"]+-44)
		-- sw ([{0 true a1 } {-36 true s0 }])
		buffer.writei32(memory, registers["s0"]+-36, registers["a1"])
		-- sw ([{0 true a0 } {-40 true s0 }])
		buffer.writei32(memory, registers["s0"]+-40, registers["a0"])
		-- j ([{0 true .LBB0_5 }])
		PC = ".LBB0_5"
	end -- .LBB0_4 (.LBB0_4)
	if PC == ".LBB0_5" and not init then -- .LBB0_5 (runtime) 
		-- lw ([{0 true a1 } {-48 true s0 }])
		registers["a1"] = buffer.readi32(memory, registers["s0"]+-48)
		-- lui ([{0 true a0 } {0 false .L.str hi}])
		registers["a0"] = hi(data["str"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str lo}])
		registers["a0"] = registers["a0"] + lo(data["str"])
		-- call ([{0 false printf }])
		functions["printf"]() -- invoke provided function printf
		-- j ([{0 true .LBB0_6 }])
		PC = ".LBB0_6"
	end -- .LBB0_5 (.LBB0_5)
	if PC == ".LBB0_6" and not init then -- .LBB0_6 (runtime) 
		-- lw ([{0 true a0 } {-20 true s0 }])
		registers["a0"] = buffer.readi32(memory, registers["s0"]+-20)
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1 }])
		registers["a0"] = registers["a0"] + 1
		-- sw ([{0 true a0 } {-20 true s0 }])
		buffer.writei32(memory, registers["s0"]+-20, registers["a0"])
		-- j ([{0 true .LBB0_1 }])
		PC = ".LBB0_1"
	end -- .LBB0_6 (.LBB0_6)
	if PC == ".LBB0_7" and not init then -- .LBB0_7 (runtime) 
		-- li ([{0 true a0 } {0 true 0 }])
		registers["a0"] = 0
		-- lw ([{0 false ra } {44 true sp }])
		registers["ra"] = buffer.readi32(memory, registers["sp"]+44)
		-- lw ([{0 true s0 } {40 true sp }])
		registers["s0"] = buffer.readi32(memory, registers["sp"]+40)
		-- addi ([{0 false sp } {0 false sp } {0 true 48 }])
		registers["sp"] = registers["sp"] + 48
		-- ret ([])
		break
	end -- .LBB0_7 (.LBB0_7)
	if PC == ".Lfunc_end0" and not init then -- .Lfunc_end0 (runtime) 
		-- ASM ATTRIBUTE: .type	.L.str,@object
		-- ASM ATTRIBUTE: .section	.rodata.str1.1,"aMS",@progbits,1
	end -- .Lfunc_end0 (.Lfunc_end0)
	if init then -- .L.str (initialization)
		buffer.writestring(memory, 0, "%d\0")
		data["str"] = 0 -- represents ^
		-- ASM ATTRIBUTE: .ident	"Homebrew clang version 20.1.8"
		-- ASM ATTRIBUTE: .section	".note.GNU-stack","",@progbits
		-- ASM ATTRIBUTE: .addrsig
		-- ASM ATTRIBUTE: .addrsig_sym printf
	end -- .L.str (.L.str)
	init = false
end
