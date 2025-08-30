-- Compiled from RISC-V assembly.
--- API
local mem = 2048 -- 2KB of RAM
local memory = buffer.create(mem) -- our memory!
local data = {} -- pointers in memory to static data, ex: strings
local labels = {}
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
local PC = -1 -- where the next iteration shall goto
local init = true -- becomes false when the buffer is polluted with static data, and labels are assigned

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

-- Localized Functions
--- bit32
local band = bit32.band
local bor = bit32.bor
local lshift = bit32.lshift
local rshift = bit32.rshift
local arshift = bit32.arshift
local bxor = bit32.bxor

--- buffer
local writestring = buffer.writestring
local writei8 = buffer.writei8
local writei16 = buffer.writei16
local writei32 = buffer.writei32
local readi8 = buffer.readi8
local readi16 = buffer.readi16
local readi32 = buffer.readi32
local writeu8 = buffer.writeu8
local writeu16 = buffer.writeu16
local writeu32 = buffer.writeu32
local readu8 = buffer.readu8
local readu16 = buffer.readu16
local readu32 = buffer.readu32

---- Auto generated code starts here
while PC ~= 0 do
	-- ASM ATTRIBUTE: .attribute	4, 16
	-- ASM ATTRIBUTE: .attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	-- ASM ATTRIBUTE: .file	"main.c"
	-- ASM ATTRIBUTE: .text
	-- ASM ATTRIBUTE: .globl	main
	-- ASM ATTRIBUTE: .p2align	2
	-- ASM ATTRIBUTE: .type	main,@function
	if PC == 1 and not init then -- main (runtime) 
		-- addi ([{0 false sp } {0 false sp } {0 true -32 }])
		registers.sp = registers.sp + -32
		-- sw ([{0 false ra } {28 true sp }])
		writei32(memory, registers.sp+28, registers.ra)
		-- sw ([{0 true s0 } {24 true sp }])
		writei32(memory, registers.sp+24, registers.s0)
		-- addi ([{0 true s0 } {0 false sp } {0 true 32 }])
		registers.s0 = registers.sp + 32
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {-28 true s0 }])
		writei32(memory, registers.s0+-28, registers.a0)
		-- sw ([{0 true a0 } {-12 true s0 }])
		writei32(memory, registers.s0+-12, registers.a0)
		-- lui ([{0 true a0 } {0 true 262290 }])
		registers.a0 = 262290
		-- addi ([{0 true a0 } {0 true a0 } {0 true -328 }])
		registers.a0 = registers.a0 + -328
		-- sw ([{0 true a0 } {-20 true s0 }])
		writei32(memory, registers.s0+-20, registers.a0)
		-- lui ([{0 true a0 } {0 true 335544 }])
		registers.a0 = 335544
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1311 }])
		registers.a0 = registers.a0 + 1311
		-- sw ([{0 true a0 } {-24 true s0 }])
		writei32(memory, registers.s0+-24, registers.a0)
		-- lw ([{0 true a3 } {-20 true s0 }])
		registers.a3 = readi32(memory, registers.s0+-20)
		-- lw ([{0 true a2 } {-24 true s0 }])
		registers.a2 = readi32(memory, registers.s0+-24)
		-- lui ([{0 true a0 } {0 false .L.str hi}])
		registers.a0 = hi(data["str"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str lo}])
		registers.a0 = registers.a0 + lo(data["str"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]() -- invoke provided function printf
			PC = 2 -- since we are cutting early
		else
			registers.ra = 2
			PC = labels["printf"]
			continue
		end
	end -- main (main)
	if PC == 2 and not init then -- main (extended) 
		-- lw ([{0 true a0 } {-28 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-28)
		-- lw ([{0 false ra } {28 true sp }])
		registers.ra = readi32(memory, registers.sp+28)
		-- lw ([{0 true s0 } {24 true sp }])
		registers.s0 = readi32(memory, registers.sp+24)
		-- addi ([{0 false sp } {0 false sp } {0 true 32 }])
		registers.sp = registers.sp + 32
		-- ret ([])
		if registers.ra ~= 0 then
			PC = registers.ra
			registers.ra = 0
			continue
		else
			PC = 0
		end
	end -- main_end (main_end)
	if PC == 3 and not init then -- .Lfunc_end0 (runtime) 
		-- ASM ATTRIBUTE: .type	.L.str,@object
		-- ASM ATTRIBUTE: .section	.rodata.str1.1,"aMS",@progbits,1
	end -- .Lfunc_end0 (.Lfunc_end0)
	if init then -- .L.str (initialization)
		writestring(memory, 0, "The value of x is %f\n\0")
		data["str"] = 0 -- represents ^
		-- ASM ATTRIBUTE: .ident	"Homebrew clang version 20.1.8"
		-- ASM ATTRIBUTE: .section	".note.GNU-stack","",@progbits
		-- ASM ATTRIBUTE: .addrsig
		-- ASM ATTRIBUTE: .addrsig_sym printf
	end -- .L.str (.L.str)
	if init then -- load label names for quick access
		labels = {
			["main"] = 1,
			["main_end"] = 2,
			[".Lfunc_end0"] = 3,
			[".L.str"] = 4,
		}
		PC = labels["main"]
	end
	init = false -- do not initialize again
	-- if no PC, or invalid PC then break (look into alternative implementations in the future) 
	if (not PC) or PC == 0 or PC > 4 then
		break
	end
end
