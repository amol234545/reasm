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
    ["x31"]  = 0,

    -- Floating point
    ["ft0"]  = 0, ["ft1"]  = 0, ["ft2"]  = 0, ["ft3"]  = 0,
    ["ft4"]  = 0, ["ft5"]  = 0, ["ft6"]  = 0, ["ft7"]  = 0,
    ["ft8"]  = 0, ["ft9"]  = 0, ["ft10"] = 0, ["ft11"] = 0,

    ["fs0"]  = 0, ["fs1"]  = 0, ["fs2"]  = 0, ["fs3"]  = 0,
    ["fs4"]  = 0, ["fs5"]  = 0, ["fs6"]  = 0, ["fs7"]  = 0,
    ["fs8"]  = 0, ["fs9"]  = 0, ["fs10"] = 0, ["fs11"] = 0,

    ["fa0"]  = 0, ["fa1"]  = 0, ["fa2"]  = 0, ["fa3"]  = 0,
    ["fa4"]  = 0, ["fa5"]  = 0, ["fa6"]  = 0, ["fa7"]  = 0
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
		-- addi ([{0 false sp } {0 false sp } {0 true -48 }])
		registers.sp = registers.sp + -48
		-- sw ([{0 false ra } {44 true sp }])
		writei32(memory, registers.sp+44, registers.ra)
		-- sw ([{0 true s0 } {40 true sp }])
		writei32(memory, registers.sp+40, registers.s0)
		-- addi ([{0 true s0 } {0 false sp } {0 true 48 }])
		registers.s0 = registers.sp + 48
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {-28 true s0 }])
		writei32(memory, registers.s0+-28, registers.a0)
		-- sw ([{0 true a0 } {-12 true s0 }])
		writei32(memory, registers.s0+-12, registers.a0)
		-- lui ([{0 true a0 } {0 true 263680 }])
		registers.a0 = 263680
		-- sw ([{0 true a0 } {-16 true s0 }])
		writei32(memory, registers.s0+-16, registers.a0)
		-- lui ([{0 true a0 } {0 true 262144 }])
		registers.a0 = 262144
		-- sw ([{0 true a0 } {-20 true s0 }])
		writei32(memory, registers.s0+-20, registers.a0)
		-- lw ([{0 true a0 } {-16 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-16)
		-- sw ([{0 true a0 } {-44 true s0 }])
		writei32(memory, registers.s0+-44, registers.a0)
		-- lw ([{0 true a1 } {-20 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-20)
		-- mv ([{0 true a0 } {0 true a1 }])
		registers.a0 = registers.a1
		-- call ([{0 true __mulsf3 }])
		if functions["__mulsf3"] then
			functions["__mulsf3"]()
			PC = 2
			continue
		else
			do
				registers.ra = 2
				PC = labels["__mulsf3"]
				continue
			end
		end
		PC += 1
	end -- main (main)
	if PC == 2 and not init then -- main (extended) 
		-- lw ([{0 true a1 } {-44 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-44)
		-- sw ([{0 true a0 } {-40 true s0 }])
		writei32(memory, registers.s0+-40, registers.a0)
		-- mv ([{0 true a0 } {0 true a1 }])
		registers.a0 = registers.a1
		-- call ([{0 true __mulsf3 }])
		if functions["__mulsf3"] then
			functions["__mulsf3"]()
			PC = 3
			continue
		else
			do
				registers.ra = 3
				PC = labels["__mulsf3"]
				continue
			end
		end
		PC += 1
	end -- main_end (main_end)
	if PC == 3 and not init then -- main_end (extended) 
		-- lw ([{0 true a1 } {-40 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-40)
		-- call ([{0 true __addsf3 }])
		if functions["__addsf3"] then
			functions["__addsf3"]()
			PC = 4
			continue
		else
			do
				registers.ra = 4
				PC = labels["__addsf3"]
				continue
			end
		end
		PC += 1
	end -- main_end_end (main_end_end)
	if PC == 4 and not init then -- main_end_end (extended) 
		-- sw ([{0 true a0 } {-24 true s0 }])
		writei32(memory, registers.s0+-24, registers.a0)
		-- lw ([{0 true a0 } {-16 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-16)
		-- call ([{0 false __fixsfsi }])
		if functions["__fixsfsi"] then
			functions["__fixsfsi"]()
			PC = 5
			continue
		else
			do
				registers.ra = 5
				PC = labels["__fixsfsi"]
				continue
			end
		end
		PC += 1
	end -- main_end_end_end (main_end_end_end)
	if PC == 5 and not init then -- main_end_end_end (extended) 
		-- sw ([{0 true a0 } {-36 true s0 }])
		writei32(memory, registers.s0+-36, registers.a0)
		-- lw ([{0 true a0 } {-20 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-20)
		-- call ([{0 false __fixsfsi }])
		if functions["__fixsfsi"] then
			functions["__fixsfsi"]()
			PC = 6
			continue
		else
			do
				registers.ra = 6
				PC = labels["__fixsfsi"]
				continue
			end
		end
		PC += 1
	end -- main_end_end_end_end (main_end_end_end_end)
	if PC == 6 and not init then -- main_end_end_end_end (extended) 
		-- sw ([{0 true a0 } {-32 true s0 }])
		writei32(memory, registers.s0+-32, registers.a0)
		-- lw ([{0 true a0 } {-24 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-24)
		-- call ([{0 false __fixsfsi }])
		if functions["__fixsfsi"] then
			functions["__fixsfsi"]()
			PC = 7
			continue
		else
			do
				registers.ra = 7
				PC = labels["__fixsfsi"]
				continue
			end
		end
		PC += 1
	end -- main_end_end_end_end_end (main_end_end_end_end_end)
	if PC == 7 and not init then -- main_end_end_end_end_end (extended) 
		-- lw ([{0 true a1 } {-36 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-36)
		-- lw ([{0 true a2 } {-32 true s0 }])
		registers.a2 = readi32(memory, registers.s0+-32)
		-- mv ([{0 true a3 } {0 true a0 }])
		registers.a3 = registers.a0
		-- lui ([{0 true a0 } {0 false .L.str hi}])
		registers.a0 = hi(data[".str"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str lo}])
		registers.a0 = registers.a0 + lo(data[".str"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 8
			continue
		else
			do
				registers.ra = 8
				PC = labels["printf"]
				continue
			end
		end
		PC += 1
	end -- main_end_end_end_end_end_end (main_end_end_end_end_end_end)
	if PC == 8 and not init then -- main_end_end_end_end_end_end (extended) 
		-- lw ([{0 true a0 } {-28 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-28)
		-- lw ([{0 false ra } {44 true sp }])
		registers.ra = readi32(memory, registers.sp+44)
		-- lw ([{0 true s0 } {40 true sp }])
		registers.s0 = readi32(memory, registers.sp+40)
		-- addi ([{0 false sp } {0 false sp } {0 true 48 }])
		registers.sp = registers.sp + 48
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
	end -- main_end_end_end_end_end_end_end (main_end_end_end_end_end_end_end)
	if PC == 9 and not init then -- .Lfunc_end0 (runtime) 
		-- ASM ATTRIBUTE: .type	.L.str,@object
		-- ASM ATTRIBUTE: .section	.rodata.str1.1,"aMS",@progbits,1
		PC += 1
	end -- .Lfunc_end0 (.Lfunc_end0)
	if init then -- .L.str (initialization)
		writestring(memory, 0, "Square of %d + square of %d = %d\n\0")
		data[".str"] = 0
		-- ASM ATTRIBUTE: .ident	"Homebrew clang version 20.1.8"
		-- ASM ATTRIBUTE: .section	".note.GNU-stack","",@progbits
		-- ASM ATTRIBUTE: .addrsig
		-- ASM ATTRIBUTE: .addrsig_sym printf
		PC += 1
	end -- .L.str (.L.str)
	if init then -- load label names for quick access
		labels = {
			["main"] = 1,
			["main_end"] = 2,
			["main_end_end"] = 3,
			["main_end_end_end"] = 4,
			["main_end_end_end_end"] = 5,
			["main_end_end_end_end_end"] = 6,
			["main_end_end_end_end_end_end"] = 7,
			["main_end_end_end_end_end_end_end"] = 8,
			[".Lfunc_end0"] = 9,
			[".L.str"] = 10,
		}
		PC = labels["main"]
	end
	init = false -- do not initialize again
	-- if no PC, or invalid PC then break (look into alternative implementations in the future) 
	if (not PC) or PC == 0 or PC > 10 then
		break
	end
end
