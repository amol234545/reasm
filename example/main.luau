-- Compiled from RISC-V assembly.
--- API
local mem = 2048 -- 2KB of RAM
local memory = buffer.create(mem) -- our memory!
local data = {} -- pointers in memory to static data, ex: strings
local labels = {}
local registers = {
    ["a0"] = 0,
    ["a1"] = 0,
    ["a2"] = 0,
    ["a3"] = 0,
    ["a4"] = 0,
    ["a5"] = 0,
    ["a6"] = 0,
    ["a7"] = 0,
    ["fa0"] = 0,
    ["fa1"] = 0,
    ["fa2"] = 0,
    ["fa3"] = 0,
    ["fa4"] = 0,
    ["fa5"] = 0,
    ["fa6"] = 0,
    ["fa7"] = 0,
    ["fp"] = 0,
    ["fs0"] = 0,
    ["fs1"] = 0,
    ["fs10"] = 0,
    ["fs11"] = 0,
    ["fs2"] = 0,
    ["fs3"] = 0,
    ["fs4"] = 0,
    ["fs5"] = 0,
    ["fs6"] = 0,
    ["fs7"] = 0,
    ["fs8"] = 0,
    ["fs9"] = 0,
    ["ft0"] = 0,
    ["ft1"] = 0,
    ["ft10"] = 0,
    ["ft11"] = 0,
    ["ft2"] = 0,
    ["ft3"] = 0,
    ["ft4"] = 0,
    ["ft5"] = 0,
    ["ft6"] = 0,
    ["ft7"] = 0,
    ["ft8"] = 0,
    ["ft9"] = 0,
    ["gp"] = 0,
    ["ra"] = 0,
    ["s0"] = 0,
    ["s1"] = 0,
    ["s10"] = 0,
    ["s11"] = 0,
    ["s2"] = 0,
    ["s3"] = 0,
    ["s4"] = 0,
    ["s5"] = 0,
    ["s6"] = 0,
    ["s7"] = 0,
    ["s8"] = 0,
    ["s9"] = 0,
    ["sp"] = 0,
    ["t0"] = 0,
    ["t1"] = 0,
    ["t2"] = 0,
    ["t3"] = 0,
    ["t4"] = 0,
    ["t5"] = 0,
    ["t6"] = 0,
    ["tp"] = 0,
    ["x0"] = 0,
    ["x1"] = 0,
    ["x10"] = 0,
    ["x11"] = 0,
    ["x12"] = 0,
    ["x13"] = 0,
    ["x14"] = 0,
    ["x15"] = 0,
    ["x16"] = 0,
    ["x17"] = 0,
    ["x18"] = 0,
    ["x19"] = 0,
    ["x2"] = 0,
    ["x20"] = 0,
    ["x21"] = 0,
    ["x22"] = 0,
    ["x23"] = 0,
    ["x24"] = 0,
    ["x25"] = 0,
    ["x26"] = 0,
    ["x27"] = 0,
    ["x28"] = 0,
    ["x29"] = 0,
    ["x3"] = 0,
    ["x30"] = 0,
    ["x31"] = 0,
    ["x4"] = 0,
    ["x5"] = 0,
    ["x6"] = 0,
    ["x7"] = 0,
    ["x8"] = 0,
    ["x9"] = 0,
    ["zero"] = 0,

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
function fclass(x)
    local result = 0

    if x ~= x then           -- NaN
        result = 2^9
    elseif x == math.huge then
        result = 2^7           -- positive infinity
    elseif x == -math.huge then
        result = 2^0           -- negative infinity
    elseif x == 0 then
        if 1/x > 0 then
            result = 2^4       -- positive zero
        else
            result = 2^3       -- negative zero
        end
    else
        local abs_x = math.abs(x)
        if abs_x < 2.2250738585072014e-308 then  -- subnormal range for double
            if x > 0 then
                result = 2^5   -- positive subnormal
            else
                result = 2^2   -- negative subnormal
            end
        else
            if x > 0 then
                result = 2^6   -- positive normal
            else
                result = 2^1   -- negative normal
            end
        end
    end

    return result
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
local writef32 = buffer.writef32
local writef64 = buffer.writef64
local readf32 = buffer.readf32
local readf64 = buffer.readf64

-- math
local sqrt = math.sqrt
local abs = math.abs
local sgn = math.sign
local min = math.min
local max = math.max
local floor = math.floor

registers.sp = mem/2 -- start at the center.
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
		-- addi ([{0 true sp } {0 true sp } {0 false -16 }])
		registers.sp = registers.sp + -16
		-- sw ([{0 true ra } {12 true sp }])
		writei32(memory, registers.sp+12, registers.ra)
		-- sw ([{0 true s0 } {8 true sp }])
		writei32(memory, registers.sp+8, registers.s0)
		-- addi ([{0 true s0 } {0 true sp } {0 false 16 }])
		registers.s0 = registers.sp + 16
		-- li ([{0 true a0 } {0 false 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {-12 true s0 }])
		writei32(memory, registers.s0+-12, registers.a0)
		-- lui ([{0 true a0 } {0 false .L.str hi}])
		registers.a0 = hi(data[".L.str"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str lo}])
		registers.a0 = registers.a0 + lo(data[".L.str"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 2
			continue
		else
			do
				registers.ra = 2
				PC = labels["printf"]
				continue
			end
		end
		PC += 1
	end -- main (main)
	if PC == 2 and not init then -- main (extended) 
		-- li ([{0 true a0 } {0 false 1 }])
		registers.a0 = 1
		-- sw ([{0 true a0 } {-16 true s0 }])
		writei32(memory, registers.s0+-16, registers.a0)
		-- j ([{0 false .LBB0_1 }])
		do
			PC = labels[".LBB0_1"]
			continue
		end
		PC += 1
	end -- main_end (main_end)
	if PC == 3 and not init then -- .LBB0_1 (runtime) 
		-- lw ([{0 true a1 } {-16 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-16)
		-- li ([{0 true a0 } {0 false 5 }])
		registers.a0 = 5
		-- blt ([{0 true a0 } {0 true a1 } {0 false .LBB0_4 }])
		if registers.a0 < registers.a1 then
			do
				PC = labels[".LBB0_4"]
				continue
			end
		end
		-- j ([{0 false .LBB0_2 }])
		do
			PC = labels[".LBB0_2"]
			continue
		end
		PC += 1
	end -- .LBB0_1 (.LBB0_1)
	if PC == 4 and not init then -- .LBB0_2 (runtime) 
		-- lw ([{0 true a1 } {-16 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-16)
		-- lui ([{0 true a0 } {0 false .L.str.1 hi}])
		registers.a0 = hi(data[".L.str.1"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str.1 lo}])
		registers.a0 = registers.a0 + lo(data[".L.str.1"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 5
			continue
		else
			do
				registers.ra = 5
				PC = labels["printf"]
				continue
			end
		end
		PC += 1
	end -- .LBB0_2 (.LBB0_2)
	if PC == 5 and not init then -- .LBB0_2 (extended) 
		-- j ([{0 false .LBB0_3 }])
		do
			PC = labels[".LBB0_3"]
			continue
		end
		PC += 1
	end -- .LBB0_2_end (.LBB0_2_end)
	if PC == 6 and not init then -- .LBB0_3 (runtime) 
		-- lw ([{0 true a0 } {-16 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-16)
		-- addi ([{0 true a0 } {0 true a0 } {0 false 1 }])
		registers.a0 = registers.a0 + 1
		-- sw ([{0 true a0 } {-16 true s0 }])
		writei32(memory, registers.s0+-16, registers.a0)
		-- j ([{0 false .LBB0_1 }])
		do
			PC = labels[".LBB0_1"]
			continue
		end
		PC += 1
	end -- .LBB0_3 (.LBB0_3)
	if PC == 7 and not init then -- .LBB0_4 (runtime) 
		-- li ([{0 true a0 } {0 false 0 }])
		registers.a0 = 0
		-- lw ([{0 true ra } {12 true sp }])
		registers.ra = readi32(memory, registers.sp+12)
		-- lw ([{0 true s0 } {8 true sp }])
		registers.s0 = readi32(memory, registers.sp+8)
		-- addi ([{0 true sp } {0 true sp } {0 false 16 }])
		registers.sp = registers.sp + 16
		-- ret ([])
		if registers.ra ~= 0 then
			PC = registers.ra
			registers.ra = 0
			continue
		else
			PC = 0
			continue
		end
		PC += 1
	end -- .LBB0_4 (.LBB0_4)
	if PC == 8 and not init then -- .Lfunc_end0 (runtime) 
		-- ASM ATTRIBUTE: .type	.L.str,@object
		-- ASM ATTRIBUTE: .section	.rodata.str1.1,"aMS",@progbits,1
		PC += 1
	end -- .Lfunc_end0 (.Lfunc_end0)
	if init then -- .L.str (initialization)
		writestring(memory, 0, "For loop:\0")
		data[".L.str"] = 0
		-- ASM ATTRIBUTE: .type	.L.str.1,@object
		PC += 1
	end -- .L.str (.L.str)
	if init then -- .L.str.1 (initialization)
		writestring(memory, 10, "%d\0")
		data[".L.str.1"] = 10
		-- ASM ATTRIBUTE: .ident	"Homebrew clang version 20.1.8"
		-- ASM ATTRIBUTE: .section	".note.GNU-stack","",@progbits
		-- ASM ATTRIBUTE: .addrsig
		-- ASM ATTRIBUTE: .addrsig_sym printf
		PC += 1
	end -- .L.str.1 (.L.str.1)
	if init then -- load label names for quick access
		labels = {
			["main"] = 1,
			["main_end"] = 2,
			[".LBB0_1"] = 3,
			[".LBB0_2"] = 4,
			[".LBB0_2_end"] = 5,
			[".LBB0_3"] = 6,
			[".LBB0_4"] = 7,
			[".Lfunc_end0"] = 8,
			[".L.str"] = 9,
			[".L.str.1"] = 10,
		}
		PC = labels["main"]
	end
	init = false -- do not initialize again
	-- if no PC, or invalid PC then break (look into alternative implementations in the future) 
	if (not PC) or PC == 0 or PC > 10 then
		break
	end
end
