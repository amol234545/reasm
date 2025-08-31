-- Compiled from RISC-V assembly.
--- API
local mem = 2048 -- 2KB of RAM
local memory = buffer.create(mem) -- our memory!
local data = {} -- pointers in memory to static data, ex: strings
local labels = {}
local registers = {
    ["zero"] = 0,    ["x0"]  = 0,     ["ra"]   = 0,    ["x1"]  = 0,
    ["sp"]   = mem/2,  ["x2"]  = 0,     ["gp"]   = 0,    ["x3"]  = 0,
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
		-- addi ([{0 false sp } {0 false sp } {0 true -160 }])
		registers.sp = registers.sp + -160
		-- sw ([{0 false ra } {-100 true sp }])
		writei32(memory, registers.sp+-100, registers.ra)
		-- sw ([{0 true s0 } {-104 true sp }])
		writei32(memory, registers.sp+-104, registers.s0)
		-- addi ([{0 true s0 } {0 false sp } {0 true 160 }])
		registers.s0 = registers.sp + 160
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {104 true s0 }])
		writei32(memory, registers.s0+104, registers.a0)
		-- sw ([{0 true a0 } {-12 true s0 }])
		writei32(memory, registers.s0+-12, registers.a0)
		-- sw ([{0 true a0 } {-80 true s0 }])
		writei32(memory, registers.s0+-80, registers.a0)
		-- sw ([{0 true a0 } {-84 true s0 }])
		writei32(memory, registers.s0+-84, registers.a0)
		-- sw ([{0 true a0 } {-88 true s0 }])
		writei32(memory, registers.s0+-88, registers.a0)
		-- sw ([{0 true a0 } {-92 true s0 }])
		writei32(memory, registers.s0+-92, registers.a0)
		-- sw ([{0 true a0 } {-96 true s0 }])
		writei32(memory, registers.s0+-96, registers.a0)
		-- sw ([{0 true a0 } {-100 true s0 }])
		writei32(memory, registers.s0+-100, registers.a0)
		-- sw ([{0 true a0 } {-104 true s0 }])
		writei32(memory, registers.s0+-104, registers.a0)
		-- sw ([{0 true a0 } {-108 true s0 }])
		writei32(memory, registers.s0+-108, registers.a0)
		-- sw ([{0 true a0 } {-112 true s0 }])
		writei32(memory, registers.s0+-112, registers.a0)
		-- sw ([{0 true a0 } {-116 true s0 }])
		writei32(memory, registers.s0+-116, registers.a0)
		-- li ([{0 true a1 } {0 true 1 }])
		registers.a1 = 1
		-- sw ([{0 true a1 } {-120 true s0 }])
		writei32(memory, registers.s0+-120, registers.a1)
		-- sw ([{0 true a0 } {-124 true s0 }])
		writei32(memory, registers.s0+-124, registers.a0)
		-- j ([{0 true .LBB0_1 }])
		do
			PC = labels[".LBB0_1"]
			print(PC)
			continue
		end
		PC += 1
	end -- main (main)
	if PC == 2 and not init then -- .LBB0_1 (runtime) 
		-- lw ([{0 true a1 } {-124 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-124)
		-- li ([{0 true a0 } {0 true 3 }])
		registers.a0 = 3
		-- blt ([{0 true a0 } {0 true a1 } {0 true .LBB0_8 }])
		if registers.a0 < registers.a1 then
			do
				PC = labels[".LBB0_8"]
				print(PC)
				continue
			end
		end
		-- j ([{0 true .LBB0_2 }])
		do
			PC = labels[".LBB0_2"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_1 (.LBB0_1)
	if PC == 3 and not init then -- .LBB0_2 (runtime) 
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {-128 true s0 }])
		writei32(memory, registers.s0+-128, registers.a0)
		-- j ([{0 true .LBB0_3 }])
		do
			PC = labels[".LBB0_3"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_2 (.LBB0_2)
	if PC == 4 and not init then -- .LBB0_3 (runtime) 
		-- lw ([{0 true a1 } {-128 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-128)
		-- li ([{0 true a0 } {0 true 3 }])
		registers.a0 = 3
		-- blt ([{0 true a0 } {0 true a1 } {0 true .LBB0_6 }])
		if registers.a0 < registers.a1 then
			do
				PC = labels[".LBB0_6"]
				print(PC)
				continue
			end
		end
		-- j ([{0 true .LBB0_4 }])
		do
			PC = labels[".LBB0_4"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_3 (.LBB0_3)
	if PC == 5 and not init then -- .LBB0_4 (runtime) 
		-- lw ([{0 true a1 } {-124 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-124)
		-- slli ([{0 true a0 } {0 true a1 } {0 true 2 }])
		registers.a0 = band(lshift(registers.a1, 2), 0xFFFFFFFF)
		-- lw ([{0 true a2 } {-128 true s0 }])
		registers.a2 = readi32(memory, registers.s0+-128)
		-- add ([{0 true a0 } {0 true a0 } {0 true a2 }])
		registers.a0 = registers.a0 + registers.a2
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1 }])
		registers.a0 = registers.a0 + 1
		-- slli ([{0 true a3 } {0 true a1 } {0 true 4 }])
		registers.a3 = band(lshift(registers.a1, 4), 0xFFFFFFFF)
		-- addi ([{0 true a1 } {0 true s0 } {0 true -76 }])
		registers.a1 = registers.s0 + -76
		-- add ([{0 true a1 } {0 true a1 } {0 true a3 }])
		registers.a1 = registers.a1 + registers.a3
		-- slli ([{0 true a2 } {0 true a2 } {0 true 2 }])
		registers.a2 = band(lshift(registers.a2, 2), 0xFFFFFFFF)
		-- add ([{0 true a1 } {0 true a1 } {0 true a2 }])
		registers.a1 = registers.a1 + registers.a2
		-- sw ([{0 true a0 } {0 true a1 }])
		writei32(memory, registers.a1, registers.a0)
		-- j ([{0 true .LBB0_5 }])
		do
			PC = labels[".LBB0_5"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_4 (.LBB0_4)
	if PC == 6 and not init then -- .LBB0_5 (runtime) 
		-- lw ([{0 true a0 } {-128 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-128)
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1 }])
		registers.a0 = registers.a0 + 1
		-- sw ([{0 true a0 } {-128 true s0 }])
		writei32(memory, registers.s0+-128, registers.a0)
		-- j ([{0 true .LBB0_3 }])
		do
			PC = labels[".LBB0_3"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_5 (.LBB0_5)
	if PC == 7 and not init then -- .LBB0_6 (runtime) 
		-- j ([{0 true .LBB0_7 }])
		do
			PC = labels[".LBB0_7"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_6 (.LBB0_6)
	if PC == 8 and not init then -- .LBB0_7 (runtime) 
		-- lw ([{0 true a0 } {-124 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-124)
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1 }])
		registers.a0 = registers.a0 + 1
		-- sw ([{0 true a0 } {-124 true s0 }])
		writei32(memory, registers.s0+-124, registers.a0)
		-- j ([{0 true .LBB0_1 }])
		do
			PC = labels[".LBB0_1"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_7 (.LBB0_7)
	if PC == 9 and not init then -- .LBB0_8 (runtime) 
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {124 true s0 }])
		writei32(memory, registers.s0+124, registers.a0)
		-- j ([{0 true .LBB0_9 }])
		do
			PC = labels[".LBB0_9"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_8 (.LBB0_8)
	if PC == 10 and not init then -- .LBB0_9 (runtime) 
		-- lw ([{0 true a1 } {124 true s0 }])
		registers.a1 = readi32(memory, registers.s0+124)
		-- li ([{0 true a0 } {0 true 3 }])
		registers.a0 = 3
		-- blt ([{0 true a0 } {0 true a1 } {0 true .LBB0_18 }])
		if registers.a0 < registers.a1 then
			do
				PC = labels[".LBB0_18"]
				print(PC)
				continue
			end
		end
		-- j ([{0 true .LBB0_10 }])
		do
			PC = labels[".LBB0_10"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_9 (.LBB0_9)
	if PC == 11 and not init then -- .LBB0_10 (runtime) 
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {120 true s0 }])
		writei32(memory, registers.s0+120, registers.a0)
		-- j ([{0 true .LBB0_11 }])
		do
			PC = labels[".LBB0_11"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_10 (.LBB0_10)
	if PC == 12 and not init then -- .LBB0_11 (runtime) 
		-- lw ([{0 true a1 } {120 true s0 }])
		registers.a1 = readi32(memory, registers.s0+120)
		-- li ([{0 true a0 } {0 true 3 }])
		registers.a0 = 3
		-- blt ([{0 true a0 } {0 true a1 } {0 true .LBB0_16 }])
		if registers.a0 < registers.a1 then
			do
				PC = labels[".LBB0_16"]
				print(PC)
				continue
			end
		end
		-- j ([{0 true .LBB0_12 }])
		do
			PC = labels[".LBB0_12"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_11 (.LBB0_11)
	if PC == 13 and not init then -- .LBB0_12 (runtime) 
		-- lw ([{0 true a1 } {124 true s0 }])
		registers.a1 = readi32(memory, registers.s0+124)
		-- slli ([{0 true a2 } {0 true a1 } {0 true 4 }])
		registers.a2 = band(lshift(registers.a1, 4), 0xFFFFFFFF)
		-- addi ([{0 true a0 } {0 true s0 } {0 true -76 }])
		registers.a0 = registers.s0 + -76
		-- add ([{0 true a2 } {0 true a0 } {0 true a2 }])
		registers.a2 = registers.a0 + registers.a2
		-- lw ([{0 true a3 } {120 true s0 }])
		registers.a3 = readi32(memory, registers.s0+120)
		-- slli ([{0 true a3 } {0 true a3 } {0 true 2 }])
		registers.a3 = band(lshift(registers.a3, 2), 0xFFFFFFFF)
		-- add ([{0 true a2 } {0 true a2 } {0 true a3 }])
		registers.a2 = registers.a2 + registers.a3
		-- lw ([{0 true a3 } {0 true a2 }])
		registers.a3 = readi32(memory, registers.a2)
		-- slli ([{0 true a2 } {0 true a1 } {0 true 2 }])
		registers.a2 = band(lshift(registers.a1, 2), 0xFFFFFFFF)
		-- addi ([{0 true a1 } {0 true s0 } {0 true -92 }])
		registers.a1 = registers.s0 + -92
		-- add ([{0 true a2 } {0 true a1 } {0 true a2 }])
		registers.a2 = registers.a1 + registers.a2
		-- lw ([{0 true a1 } {0 true a2 }])
		registers.a1 = readi32(memory, registers.a2)
		-- add ([{0 true a1 } {0 true a1 } {0 true a3 }])
		registers.a1 = registers.a1 + registers.a3
		-- sw ([{0 true a1 } {0 true a2 }])
		writei32(memory, registers.a2, registers.a1)
		-- lw ([{0 true a1 } {124 true s0 }])
		registers.a1 = readi32(memory, registers.s0+124)
		-- slli ([{0 true a1 } {0 true a1 } {0 true 4 }])
		registers.a1 = band(lshift(registers.a1, 4), 0xFFFFFFFF)
		-- add ([{0 true a1 } {0 true a0 } {0 true a1 }])
		registers.a1 = registers.a0 + registers.a1
		-- lw ([{0 true a2 } {120 true s0 }])
		registers.a2 = readi32(memory, registers.s0+120)
		-- slli ([{0 true a2 } {0 true a2 } {0 true 2 }])
		registers.a2 = band(lshift(registers.a2, 2), 0xFFFFFFFF)
		-- add ([{0 true a1 } {0 true a1 } {0 true a2 }])
		registers.a1 = registers.a1 + registers.a2
		-- lw ([{0 true a3 } {0 true a1 }])
		registers.a3 = readi32(memory, registers.a1)
		-- addi ([{0 true a1 } {0 true s0 } {0 true -108 }])
		registers.a1 = registers.s0 + -108
		-- add ([{0 true a2 } {0 true a1 } {0 true a2 }])
		registers.a2 = registers.a1 + registers.a2
		-- lw ([{0 true a1 } {0 true a2 }])
		registers.a1 = readi32(memory, registers.a2)
		-- add ([{0 true a1 } {0 true a1 } {0 true a3 }])
		registers.a1 = registers.a1 + registers.a3
		-- sw ([{0 true a1 } {0 true a2 }])
		writei32(memory, registers.a2, registers.a1)
		-- lw ([{0 true a1 } {124 true s0 }])
		registers.a1 = readi32(memory, registers.s0+124)
		-- slli ([{0 true a1 } {0 true a1 } {0 true 4 }])
		registers.a1 = band(lshift(registers.a1, 4), 0xFFFFFFFF)
		-- add ([{0 true a1 } {0 true a0 } {0 true a1 }])
		registers.a1 = registers.a0 + registers.a1
		-- lw ([{0 true a2 } {120 true s0 }])
		registers.a2 = readi32(memory, registers.s0+120)
		-- slli ([{0 true a2 } {0 true a2 } {0 true 2 }])
		registers.a2 = band(lshift(registers.a2, 2), 0xFFFFFFFF)
		-- add ([{0 true a1 } {0 true a1 } {0 true a2 }])
		registers.a1 = registers.a1 + registers.a2
		-- lw ([{0 true a2 } {0 true a1 }])
		registers.a2 = readi32(memory, registers.a1)
		-- lw ([{0 true a1 } {-112 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-112)
		-- add ([{0 true a1 } {0 true a1 } {0 true a2 }])
		registers.a1 = registers.a1 + registers.a2
		-- sw ([{0 true a1 } {-112 true s0 }])
		writei32(memory, registers.s0+-112, registers.a1)
		-- lw ([{0 true a1 } {124 true s0 }])
		registers.a1 = readi32(memory, registers.s0+124)
		-- slli ([{0 true a1 } {0 true a1 } {0 true 4 }])
		registers.a1 = band(lshift(registers.a1, 4), 0xFFFFFFFF)
		-- add ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 + registers.a1
		-- lw ([{0 true a1 } {120 true s0 }])
		registers.a1 = readi32(memory, registers.s0+120)
		-- slli ([{0 true a1 } {0 true a1 } {0 true 2 }])
		registers.a1 = band(lshift(registers.a1, 2), 0xFFFFFFFF)
		-- add ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 + registers.a1
		-- lw ([{0 true a1 } {0 true a0 }])
		registers.a1 = readi32(memory, registers.a0)
		-- lw ([{0 true a0 } {-116 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-116)
		-- xor ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = bxor(registers.a0, registers.a1)
		-- sw ([{0 true a0 } {-116 true s0 }])
		writei32(memory, registers.s0+-116, registers.a0)
		-- lw ([{0 true a0 } {124 true s0 }])
		registers.a0 = readi32(memory, registers.s0+124)
		-- lw ([{0 true a1 } {120 true s0 }])
		registers.a1 = readi32(memory, registers.s0+120)
		-- bne ([{0 true a0 } {0 true a1 } {0 true .LBB0_14 }])
		if registers.a0 ~= registers.a1 then
			do
				PC = labels[".LBB0_14"]
				print(PC)
				continue
			end
		end
		-- j ([{0 true .LBB0_13 }])
		do
			PC = labels[".LBB0_13"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_12 (.LBB0_12)
	if PC == 14 and not init then -- .LBB0_13 (runtime) 
		-- lw ([{0 true a0 } {124 true s0 }])
		registers.a0 = readi32(memory, registers.s0+124)
		-- slli ([{0 true a1 } {0 true a0 } {0 true 4 }])
		registers.a1 = band(lshift(registers.a0, 4), 0xFFFFFFFF)
		-- addi ([{0 true a0 } {0 true s0 } {0 true -76 }])
		registers.a0 = registers.s0 + -76
		-- add ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 + registers.a1
		-- lw ([{0 true a1 } {120 true s0 }])
		registers.a1 = readi32(memory, registers.s0+120)
		-- slli ([{0 true a1 } {0 true a1 } {0 true 2 }])
		registers.a1 = band(lshift(registers.a1, 2), 0xFFFFFFFF)
		-- add ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 + registers.a1
		-- lw ([{0 true a1 } {0 true a0 }])
		registers.a1 = readi32(memory, registers.a0)
		-- lw ([{0 true a0 } {-120 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-120)
		-- mul ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 * registers.a1
		-- sw ([{0 true a0 } {-120 true s0 }])
		writei32(memory, registers.s0+-120, registers.a0)
		-- j ([{0 true .LBB0_14 }])
		do
			PC = labels[".LBB0_14"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_13 (.LBB0_13)
	if PC == 15 and not init then -- .LBB0_14 (runtime) 
		-- j ([{0 true .LBB0_15 }])
		do
			PC = labels[".LBB0_15"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_14 (.LBB0_14)
	if PC == 16 and not init then -- .LBB0_15 (runtime) 
		-- lw ([{0 true a0 } {120 true s0 }])
		registers.a0 = readi32(memory, registers.s0+120)
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1 }])
		registers.a0 = registers.a0 + 1
		-- sw ([{0 true a0 } {120 true s0 }])
		writei32(memory, registers.s0+120, registers.a0)
		-- j ([{0 true .LBB0_11 }])
		do
			PC = labels[".LBB0_11"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_15 (.LBB0_15)
	if PC == 17 and not init then -- .LBB0_16 (runtime) 
		-- j ([{0 true .LBB0_17 }])
		do
			PC = labels[".LBB0_17"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_16 (.LBB0_16)
	if PC == 18 and not init then -- .LBB0_17 (runtime) 
		-- lw ([{0 true a0 } {124 true s0 }])
		registers.a0 = readi32(memory, registers.s0+124)
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1 }])
		registers.a0 = registers.a0 + 1
		-- sw ([{0 true a0 } {124 true s0 }])
		writei32(memory, registers.s0+124, registers.a0)
		-- j ([{0 true .LBB0_9 }])
		do
			PC = labels[".LBB0_9"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_17 (.LBB0_17)
	if PC == 19 and not init then -- .LBB0_18 (runtime) 
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {116 true s0 }])
		writei32(memory, registers.s0+116, registers.a0)
		-- j ([{0 true .LBB0_19 }])
		do
			PC = labels[".LBB0_19"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_18 (.LBB0_18)
	if PC == 20 and not init then -- .LBB0_19 (runtime) 
		-- lw ([{0 true a1 } {116 true s0 }])
		registers.a1 = readi32(memory, registers.s0+116)
		-- li ([{0 true a0 } {0 true 3 }])
		registers.a0 = 3
		-- blt ([{0 true a0 } {0 true a1 } {0 true .LBB0_28 }])
		if registers.a0 < registers.a1 then
			do
				PC = labels[".LBB0_28"]
				print(PC)
				continue
			end
		end
		-- j ([{0 true .LBB0_20 }])
		do
			PC = labels[".LBB0_20"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_19 (.LBB0_19)
	if PC == 21 and not init then -- .LBB0_20 (runtime) 
		-- lw ([{0 true a0 } {116 true s0 }])
		registers.a0 = readi32(memory, registers.s0+116)
		-- slli ([{0 true a1 } {0 true a0 } {0 true 2 }])
		registers.a1 = band(lshift(registers.a0, 2), 0xFFFFFFFF)
		-- addi ([{0 true a0 } {0 true s0 } {0 true -92 }])
		registers.a0 = registers.s0 + -92
		-- add ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 + registers.a1
		-- lw ([{0 true a0 } {0 true a0 }])
		registers.a0 = readi32(memory, registers.a0)
		-- srli ([{0 true a1 } {0 true a0 } {0 true 31 }])
		registers.a1 = band(rshift(registers.a0, 31), 0xFFFFFFFF)
		-- add ([{0 true a1 } {0 true a0 } {0 true a1 }])
		registers.a1 = registers.a0 + registers.a1
		-- andi ([{0 true a1 } {0 true a1 } {0 true -2 }])
		registers.a1 = band(registers.a1, -2)
		-- sub ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 - registers.a1
		-- bnez ([{0 true a0 } {0 true .LBB0_22 }])
		if registers.a0 ~= 0 then
			do
				PC = labels[".LBB0_22"]
				print(PC)
				continue
			end
		end
		-- j ([{0 true .LBB0_21 }])
		do
			PC = labels[".LBB0_21"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_20 (.LBB0_20)
	if PC == 22 and not init then -- .LBB0_21 (runtime) 
		-- lw ([{0 true a1 } {116 true s0 }])
		registers.a1 = readi32(memory, registers.s0+116)
		-- slli ([{0 true a2 } {0 true a1 } {0 true 2 }])
		registers.a2 = band(lshift(registers.a1, 2), 0xFFFFFFFF)
		-- addi ([{0 true a0 } {0 true s0 } {0 true -92 }])
		registers.a0 = registers.s0 + -92
		-- add ([{0 true a0 } {0 true a0 } {0 true a2 }])
		registers.a0 = registers.a0 + registers.a2
		-- lw ([{0 true a2 } {0 true a0 }])
		registers.a2 = readi32(memory, registers.a0)
		-- lui ([{0 true a0 } {0 false .L.str hi}])
		registers.a0 = hi(data[".str"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str lo}])
		registers.a0 = registers.a0 + lo(data[".str"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 23
			print(PC)
			continue
		else
			do
				registers.ra = 23
				PC = labels["printf"]
				print(PC)
				continue
			end
		end
		PC += 1
	end -- .LBB0_21 (.LBB0_21)
	if PC == 23 and not init then -- .LBB0_21 (extended) 
		-- j ([{0 true .LBB0_23 }])
		do
			PC = labels[".LBB0_23"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_21_end (.LBB0_21_end)
	if PC == 24 and not init then -- .LBB0_22 (runtime) 
		-- lw ([{0 true a1 } {116 true s0 }])
		registers.a1 = readi32(memory, registers.s0+116)
		-- slli ([{0 true a2 } {0 true a1 } {0 true 2 }])
		registers.a2 = band(lshift(registers.a1, 2), 0xFFFFFFFF)
		-- addi ([{0 true a0 } {0 true s0 } {0 true -92 }])
		registers.a0 = registers.s0 + -92
		-- add ([{0 true a0 } {0 true a0 } {0 true a2 }])
		registers.a0 = registers.a0 + registers.a2
		-- lw ([{0 true a2 } {0 true a0 }])
		registers.a2 = readi32(memory, registers.a0)
		-- lui ([{0 true a0 } {0 true .L.str.1 hi}])
		registers.a0 = hi(data[".str.1"])
		-- addi ([{0 true a0 } {0 true a0 } {0 true .L.str.1 lo}])
		registers.a0 = registers.a0 + lo(data[".str.1"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 25
			print(PC)
			continue
		else
			do
				registers.ra = 25
				PC = labels["printf"]
				print(PC)
				continue
			end
		end
		PC += 1
	end -- .LBB0_22 (.LBB0_22)
	if PC == 25 and not init then -- .LBB0_22 (extended) 
		-- j ([{0 true .LBB0_23 }])
		do
			PC = labels[".LBB0_23"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_22_end (.LBB0_22_end)
	if PC == 26 and not init then -- .LBB0_23 (runtime) 
		-- lw ([{0 true a0 } {116 true s0 }])
		registers.a0 = readi32(memory, registers.s0+116)
		-- slli ([{0 true a1 } {0 true a0 } {0 true 2 }])
		registers.a1 = band(lshift(registers.a0, 2), 0xFFFFFFFF)
		-- addi ([{0 true a0 } {0 true s0 } {0 true -108 }])
		registers.a0 = registers.s0 + -108
		-- add ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 + registers.a1
		-- lw ([{0 true a0 } {0 true a0 }])
		registers.a0 = readi32(memory, registers.a0)
		-- srli ([{0 true a1 } {0 true a0 } {0 true 31 }])
		registers.a1 = band(rshift(registers.a0, 31), 0xFFFFFFFF)
		-- add ([{0 true a1 } {0 true a0 } {0 true a1 }])
		registers.a1 = registers.a0 + registers.a1
		-- andi ([{0 true a1 } {0 true a1 } {0 true -2 }])
		registers.a1 = band(registers.a1, -2)
		-- sub ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = registers.a0 - registers.a1
		-- bnez ([{0 true a0 } {0 true .LBB0_25 }])
		if registers.a0 ~= 0 then
			do
				PC = labels[".LBB0_25"]
				print(PC)
				continue
			end
		end
		-- j ([{0 true .LBB0_24 }])
		do
			PC = labels[".LBB0_24"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_23 (.LBB0_23)
	if PC == 27 and not init then -- .LBB0_24 (runtime) 
		-- lw ([{0 true a1 } {116 true s0 }])
		registers.a1 = readi32(memory, registers.s0+116)
		-- slli ([{0 true a2 } {0 true a1 } {0 true 2 }])
		registers.a2 = band(lshift(registers.a1, 2), 0xFFFFFFFF)
		-- addi ([{0 true a0 } {0 true s0 } {0 true -108 }])
		registers.a0 = registers.s0 + -108
		-- add ([{0 true a0 } {0 true a0 } {0 true a2 }])
		registers.a0 = registers.a0 + registers.a2
		-- lw ([{0 true a2 } {0 true a0 }])
		registers.a2 = readi32(memory, registers.a0)
		-- lui ([{0 true a0 } {0 true .L.str.2 hi}])
		registers.a0 = hi(data[".str.2"])
		-- addi ([{0 true a0 } {0 true a0 } {0 true .L.str.2 lo}])
		registers.a0 = registers.a0 + lo(data[".str.2"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 28
			print(PC)
			continue
		else
			do
				registers.ra = 28
				PC = labels["printf"]
				print(PC)
				continue
			end
		end
		PC += 1
	end -- .LBB0_24 (.LBB0_24)
	if PC == 28 and not init then -- .LBB0_24 (extended) 
		-- j ([{0 true .LBB0_26 }])
		do
			PC = labels[".LBB0_26"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_24_end (.LBB0_24_end)
	if PC == 29 and not init then -- .LBB0_25 (runtime) 
		-- lw ([{0 true a1 } {116 true s0 }])
		registers.a1 = readi32(memory, registers.s0+116)
		-- slli ([{0 true a2 } {0 true a1 } {0 true 2 }])
		registers.a2 = band(lshift(registers.a1, 2), 0xFFFFFFFF)
		-- addi ([{0 true a0 } {0 true s0 } {0 true -108 }])
		registers.a0 = registers.s0 + -108
		-- add ([{0 true a0 } {0 true a0 } {0 true a2 }])
		registers.a0 = registers.a0 + registers.a2
		-- lw ([{0 true a2 } {0 true a0 }])
		registers.a2 = readi32(memory, registers.a0)
		-- lui ([{0 true a0 } {0 true .L.str.3 hi}])
		registers.a0 = hi(data[".str.3"])
		-- addi ([{0 true a0 } {0 true a0 } {0 true .L.str.3 lo}])
		registers.a0 = registers.a0 + lo(data[".str.3"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 30
			print(PC)
			continue
		else
			do
				registers.ra = 30
				PC = labels["printf"]
				print(PC)
				continue
			end
		end
		PC += 1
	end -- .LBB0_25 (.LBB0_25)
	if PC == 30 and not init then -- .LBB0_25 (extended) 
		-- j ([{0 true .LBB0_26 }])
		do
			PC = labels[".LBB0_26"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_25_end (.LBB0_25_end)
	if PC == 31 and not init then -- .LBB0_26 (runtime) 
		-- j ([{0 true .LBB0_27 }])
		do
			PC = labels[".LBB0_27"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_26 (.LBB0_26)
	if PC == 32 and not init then -- .LBB0_27 (runtime) 
		-- lw ([{0 true a0 } {116 true s0 }])
		registers.a0 = readi32(memory, registers.s0+116)
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1 }])
		registers.a0 = registers.a0 + 1
		-- sw ([{0 true a0 } {116 true s0 }])
		writei32(memory, registers.s0+116, registers.a0)
		-- j ([{0 true .LBB0_19 }])
		do
			PC = labels[".LBB0_19"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_27 (.LBB0_27)
	if PC == 33 and not init then -- .LBB0_28 (runtime) 
		-- lw ([{0 true a1 } {-112 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-112)
		-- lui ([{0 true a0 } {0 true .L.str.4 hi}])
		registers.a0 = hi(data[".str.4"])
		-- addi ([{0 true a0 } {0 true a0 } {0 true .L.str.4 lo}])
		registers.a0 = registers.a0 + lo(data[".str.4"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 34
			print(PC)
			continue
		else
			do
				registers.ra = 34
				PC = labels["printf"]
				print(PC)
				continue
			end
		end
		PC += 1
	end -- .LBB0_28 (.LBB0_28)
	if PC == 34 and not init then -- .LBB0_28 (extended) 
		-- lw ([{0 true a1 } {-116 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-116)
		-- lui ([{0 true a0 } {0 true .L.str.5 hi}])
		registers.a0 = hi(data[".str.5"])
		-- addi ([{0 true a0 } {0 true a0 } {0 true .L.str.5 lo}])
		registers.a0 = registers.a0 + lo(data[".str.5"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 35
			print(PC)
			continue
		else
			do
				registers.ra = 35
				PC = labels["printf"]
				print(PC)
				continue
			end
		end
		PC += 1
	end -- .LBB0_28_end (.LBB0_28_end)
	if PC == 35 and not init then -- .LBB0_28_end (extended) 
		-- lw ([{0 true a1 } {-120 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-120)
		-- lui ([{0 true a0 } {0 true .L.str.6 hi}])
		registers.a0 = hi(data[".str.6"])
		-- addi ([{0 true a0 } {0 true a0 } {0 true .L.str.6 lo}])
		registers.a0 = registers.a0 + lo(data[".str.6"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 36
			print(PC)
			continue
		else
			do
				registers.ra = 36
				PC = labels["printf"]
				print(PC)
				continue
			end
		end
		PC += 1
	end -- .LBB0_28_end_end (.LBB0_28_end_end)
	if PC == 36 and not init then -- .LBB0_28_end_end (extended) 
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {112 true s0 }])
		writei32(memory, registers.s0+112, registers.a0)
		-- sw ([{0 true a0 } {108 true s0 }])
		writei32(memory, registers.s0+108, registers.a0)
		-- j ([{0 true .LBB0_29 }])
		do
			PC = labels[".LBB0_29"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_28_end_end_end (.LBB0_28_end_end_end)
	if PC == 37 and not init then -- .LBB0_29 (runtime) 
		-- lw ([{0 true a1 } {108 true s0 }])
		registers.a1 = readi32(memory, registers.s0+108)
		-- li ([{0 true a0 } {0 true 15 }])
		registers.a0 = 15
		-- blt ([{0 true a0 } {0 true a1 } {0 true .LBB0_32 }])
		if registers.a0 < registers.a1 then
			do
				PC = labels[".LBB0_32"]
				print(PC)
				continue
			end
		end
		-- j ([{0 true .LBB0_30 }])
		do
			PC = labels[".LBB0_30"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_29 (.LBB0_29)
	if PC == 38 and not init then -- .LBB0_30 (runtime) 
		-- lw ([{0 true a0 } {108 true s0 }])
		registers.a0 = readi32(memory, registers.s0+108)
		-- srai ([{0 true a1 } {0 true a0 } {0 true 31 }])
		registers.a1 = band(arshift(registers.a0, 31), 0xFFFFFFFF)
		-- srli ([{0 true a1 } {0 true a1 } {0 true 30 }])
		registers.a1 = band(rshift(registers.a1, 30), 0xFFFFFFFF)
		-- add ([{0 true a1 } {0 true a0 } {0 true a1 }])
		registers.a1 = registers.a0 + registers.a1
		-- andi ([{0 true a1 } {0 true a1 } {0 true -4 }])
		registers.a1 = band(registers.a1, -4)
		-- sub ([{0 true a1 } {0 true a0 } {0 true a1 }])
		registers.a1 = registers.a0 - registers.a1
		-- sll ([{0 true a1 } {0 true a0 } {0 true a1 }])
		registers.a1 = band(lshift(registers.a0, registers.a1), 0xFFFFFFFF)
		-- lw ([{0 true a0 } {112 true s0 }])
		registers.a0 = readi32(memory, registers.s0+112)
		-- or ([{0 true a0 } {0 true a0 } {0 true a1 }])
		registers.a0 = bor(registers.a0, registers.a1)
		-- sw ([{0 true a0 } {112 true s0 }])
		writei32(memory, registers.s0+112, registers.a0)
		-- j ([{0 true .LBB0_31 }])
		do
			PC = labels[".LBB0_31"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_30 (.LBB0_30)
	if PC == 39 and not init then -- .LBB0_31 (runtime) 
		-- lw ([{0 true a0 } {108 true s0 }])
		registers.a0 = readi32(memory, registers.s0+108)
		-- addi ([{0 true a0 } {0 true a0 } {0 true 1 }])
		registers.a0 = registers.a0 + 1
		-- sw ([{0 true a0 } {108 true s0 }])
		writei32(memory, registers.s0+108, registers.a0)
		-- j ([{0 true .LBB0_29 }])
		do
			PC = labels[".LBB0_29"]
			print(PC)
			continue
		end
		PC += 1
	end -- .LBB0_31 (.LBB0_31)
	if PC == 40 and not init then -- .LBB0_32 (runtime) 
		-- lw ([{0 true a1 } {112 true s0 }])
		registers.a1 = readi32(memory, registers.s0+112)
		-- lui ([{0 true a0 } {0 true .L.str.7 hi}])
		registers.a0 = hi(data[".str.7"])
		-- addi ([{0 true a0 } {0 true a0 } {0 true .L.str.7 lo}])
		registers.a0 = registers.a0 + lo(data[".str.7"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 41
			print(PC)
			continue
		else
			do
				registers.ra = 41
				PC = labels["printf"]
				print(PC)
				continue
			end
		end
		PC += 1
	end -- .LBB0_32 (.LBB0_32)
	if PC == 41 and not init then -- .LBB0_32 (extended) 
		-- li ([{0 true a0 } {0 true 0 }])
		registers.a0 = 0
		-- lw ([{0 false ra } {-100 true sp }])
		registers.ra = readi32(memory, registers.sp+-100)
		-- lw ([{0 true s0 } {-104 true sp }])
		registers.s0 = readi32(memory, registers.sp+-104)
		-- addi ([{0 false sp } {0 false sp } {0 true 160 }])
		registers.sp = registers.sp + 160
		-- ret ([])
		if registers.ra ~= 0 then
			PC = registers.ra
			print(PC)
			registers.ra = 0
			continue
		else
			PC = 0
			continue
		end
		PC += 1
	end -- .LBB0_32_end (.LBB0_32_end)
	if PC == 42 and not init then -- .Lfunc_end0 (runtime) 
		-- ASM ATTRIBUTE: .type	.L.str,@object
		-- ASM ATTRIBUTE: .section	.rodata.str1.1,"aMS",@progbits,1
		PC += 1
	end -- .Lfunc_end0 (.Lfunc_end0)
	if init then -- .L.str (initialization)
		writestring(memory, 0, "Row %d sum is even: %d\n\0")
		data[".str"] = 0
		-- ASM ATTRIBUTE: .type	.L.str.1,@object
		PC += 1
	end -- .L.str (.L.str)
	if init then -- .L.str.1 (initialization)
		writestring(memory, 25, "Row %d sum is odd: %d\n\0")
		data[".str.1"] = 25
		-- ASM ATTRIBUTE: .type	.L.str.2,@object
		PC += 1
	end -- .L.str.1 (.L.str.1)
	if init then -- .L.str.2 (initialization)
		writestring(memory, 49, "Column %d sum is even: %d\n\0")
		data[".str.2"] = 49
		-- ASM ATTRIBUTE: .type	.L.str.3,@object
		PC += 1
	end -- .L.str.2 (.L.str.2)
	if init then -- .L.str.3 (initialization)
		writestring(memory, 77, "Column %d sum is odd: %d\n\0")
		data[".str.3"] = 77
		-- ASM ATTRIBUTE: .type	.L.str.4,@object
		PC += 1
	end -- .L.str.3 (.L.str.3)
	if init then -- .L.str.4 (initialization)
		writestring(memory, 104, "Total sum: %d\n\0")
		data[".str.4"] = 104
		-- ASM ATTRIBUTE: .type	.L.str.5,@object
		PC += 1
	end -- .L.str.4 (.L.str.4)
	if init then -- .L.str.5 (initialization)
		writestring(memory, 120, "XOR of all elements: %d\n\0")
		data[".str.5"] = 120
		-- ASM ATTRIBUTE: .type	.L.str.6,@object
		PC += 1
	end -- .L.str.5 (.L.str.5)
	if init then -- .L.str.6 (initialization)
		writestring(memory, 146, "Product of diagonal elements: %d\n\0")
		data[".str.6"] = 146
		-- ASM ATTRIBUTE: .type	.L.str.7,@object
		PC += 1
	end -- .L.str.6 (.L.str.6)
	if init then -- .L.str.7 (initialization)
		writestring(memory, 181, "Shift XOR result: %d\n\0")
		data[".str.7"] = 181
		-- ASM ATTRIBUTE: .ident	"Homebrew clang version 20.1.8"
		-- ASM ATTRIBUTE: .section	".note.GNU-stack","",@progbits
		-- ASM ATTRIBUTE: .addrsig
		-- ASM ATTRIBUTE: .addrsig_sym printf
		PC += 1
	end -- .L.str.7 (.L.str.7)
	if init then -- load label names for quick access
		labels = {
			["main"] = 1,
			[".LBB0_1"] = 2,
			[".LBB0_2"] = 3,
			[".LBB0_3"] = 4,
			[".LBB0_4"] = 5,
			[".LBB0_5"] = 6,
			[".LBB0_6"] = 7,
			[".LBB0_7"] = 8,
			[".LBB0_8"] = 9,
			[".LBB0_9"] = 10,
			[".LBB0_10"] = 11,
			[".LBB0_11"] = 12,
			[".LBB0_12"] = 13,
			[".LBB0_13"] = 14,
			[".LBB0_14"] = 15,
			[".LBB0_15"] = 16,
			[".LBB0_16"] = 17,
			[".LBB0_17"] = 18,
			[".LBB0_18"] = 19,
			[".LBB0_19"] = 20,
			[".LBB0_20"] = 21,
			[".LBB0_21"] = 22,
			[".LBB0_21_end"] = 23,
			[".LBB0_22"] = 24,
			[".LBB0_22_end"] = 25,
			[".LBB0_23"] = 26,
			[".LBB0_24"] = 27,
			[".LBB0_24_end"] = 28,
			[".LBB0_25"] = 29,
			[".LBB0_25_end"] = 30,
			[".LBB0_26"] = 31,
			[".LBB0_27"] = 32,
			[".LBB0_28"] = 33,
			[".LBB0_28_end"] = 34,
			[".LBB0_28_end_end"] = 35,
			[".LBB0_28_end_end_end"] = 36,
			[".LBB0_29"] = 37,
			[".LBB0_30"] = 38,
			[".LBB0_31"] = 39,
			[".LBB0_32"] = 40,
			[".LBB0_32_end"] = 41,
			[".Lfunc_end0"] = 42,
			[".L.str"] = 43,
			[".L.str.1"] = 44,
			[".L.str.2"] = 45,
			[".L.str.3"] = 46,
			[".L.str.4"] = 47,
			[".L.str.5"] = 48,
			[".L.str.6"] = 49,
			[".L.str.7"] = 50,
		}
		PC = labels["main"]
	end
	init = false -- do not initialize again
	-- if no PC, or invalid PC then break (look into alternative implementations in the future) 
	if (not PC) or PC == 0 or PC > 50 then
		break
	end
end
