-- Compiled from RISC-V assembly.
--- API
local mem = 2048 -- 2KB of RAM
local memory = buffer.create(mem) -- our memory!
local data = {} -- pointers in memory to data, ex: strings
local registers = {
    ["a0"] = 0,
    ["a1"] = 0,
    ["a2"] = 0,
    ["a3"] = 0,
    ["a4"] = 0,
    ["a5"] = 0,
    ["a6"] = 0,
    ["a7"] = 0,
    ["fp"] = 0,
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

--- Variables
local PC = 1 -- current position

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

-- Functions
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
    end,
    ["memcpy"] = function()
        local dest = registers["a0"]
        local src = registers["a1"]
        local count = registers["a2"]

        buffer.copy(memory, dest, memory, src, count)
    end,
}

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
PC = 1
writei32(memory, 0, 1)
writei32(memory, 4, 2)
writei32(memory, 8, 3)
writei32(memory, 12, 4)
writei32(memory, 16, 5)
writei32(memory, 20, 6)
writei32(memory, 24, 7)
writei32(memory, 28, 8)
writei32(memory, 32, 9)
data[".L__const.main.matrix1"] = 0
writei32(memory, 36, 9)
writei32(memory, 40, 8)
writei32(memory, 44, 7)
writei32(memory, 48, 6)
writei32(memory, 52, 6)
writei32(memory, 56, 4)
writei32(memory, 60, 3)
writei32(memory, 64, 2)
writei32(memory, 68, 1)
data[".L__const.main.matrix2"] = 36
writestring(memory, 72, "Result of matrix addition:\0")
data[".L.str"] = 72
writestring(memory, 99, "%d\0")
data[".L.str.1"] = 99
while PC ~= 0 do
	if PC == 1 then -- main
		registers.sp = registers.sp + -144
		writei32(memory, registers.sp+-116, registers.ra)
		writei32(memory, registers.sp+-120, registers.s0)
		registers.s0 = registers.sp + 144
		registers.a0 = 0
		writei32(memory, registers.s0+116, registers.a0)
		writei32(memory, registers.s0+-12, registers.a0)
		registers.a1 = hi(data[".L__const.main.matrix1"])
		registers.a1 = registers.a1 + lo(data[".L__const.main.matrix1"])
		registers.a0 = registers.s0 + -48
		registers.a2 = 36
		writei32(memory, registers.s0+112, registers.a2)
		if functions["memcpy"] then
			functions["memcpy"]()
			PC = 2
			continue
		else
			error("No bindings for functions 'memcpy'")
		end
		PC += 1
	end
	if PC == 2 then -- main (extended) 
		registers.a2 = readi32(memory, registers.s0+112)
		registers.a1 = hi(data[".L__const.main.matrix2"])
		registers.a1 = registers.a1 + lo(data[".L__const.main.matrix2"])
		registers.a0 = registers.s0 + -84
		if functions["memcpy"] then
			functions["memcpy"]()
			PC = 3
			continue
		else
			error("No bindings for functions 'memcpy'")
		end
		PC += 1
	end
	if PC == 3 then -- main_end (extended) 
		registers.a0 = readi32(memory, registers.s0+116)
		writei32(memory, registers.s0+-124, registers.a0)
		do
			PC = 4
			continue
		end
		PC += 1
	end
	if PC == 4 then -- .LBB0_1
		registers.a1 = readi32(memory, registers.s0+-124)
		registers.a0 = 2
		if registers.a0 < registers.a1 then
			do
				PC = 11
				continue
			end
		end
		do
			PC = 5
			continue
		end
		PC += 1
	end
	if PC == 5 then -- .LBB0_2
		registers.a0 = 0
		writei32(memory, registers.s0+-128, registers.a0)
		do
			PC = 6
			continue
		end
		PC += 1
	end
	if PC == 6 then -- .LBB0_3
		registers.a1 = readi32(memory, registers.s0+-128)
		registers.a0 = 2
		if registers.a0 < registers.a1 then
			do
				PC = 9
				continue
			end
		end
		do
			PC = 7
			continue
		end
		PC += 1
	end
	if PC == 7 then -- .LBB0_4
		registers.a0 = readi32(memory, registers.s0+-124)
		registers.a1 = band(lshift(registers.a0, 2), 0xFFFFFFFF)
		registers.a0 = band(lshift(registers.a0, 4), 0xFFFFFFFF)
		registers.a3 = registers.a0 - registers.a1
		registers.a0 = registers.s0 + -48
		registers.a0 = registers.a0 + registers.a3
		registers.a1 = readi32(memory, registers.s0+-128)
		registers.a2 = band(lshift(registers.a1, 2), 0xFFFFFFFF)
		registers.a0 = registers.a0 + registers.a2
		registers.a0 = readi32(memory, registers.a0)
		registers.a1 = registers.s0 + -84
		registers.a1 = registers.a1 + registers.a3
		registers.a1 = registers.a1 + registers.a2
		registers.a1 = readi32(memory, registers.a1)
		registers.a0 = registers.a0 + registers.a1
		registers.a1 = registers.s0 + -120
		registers.a1 = registers.a1 + registers.a3
		registers.a1 = registers.a1 + registers.a2
		writei32(memory, registers.a1, registers.a0)
		do
			PC = 8
			continue
		end
		PC += 1
	end
	if PC == 8 then -- .LBB0_5
		registers.a0 = readi32(memory, registers.s0+-128)
		registers.a0 = registers.a0 + 1
		writei32(memory, registers.s0+-128, registers.a0)
		do
			PC = 6
			continue
		end
		PC += 1
	end
	if PC == 9 then -- .LBB0_6
		do
			PC = 10
			continue
		end
		PC += 1
	end
	if PC == 10 then -- .LBB0_7
		registers.a0 = readi32(memory, registers.s0+-124)
		registers.a0 = registers.a0 + 1
		writei32(memory, registers.s0+-124, registers.a0)
		do
			PC = 4
			continue
		end
		PC += 1
	end
	if PC == 11 then -- .LBB0_8
		registers.a0 = hi(data[".L.str"])
		registers.a0 = registers.a0 + lo(data[".L.str"])
		if functions["printf"] then
			functions["printf"]()
			PC = 12
			continue
		else
			error("No bindings for functions 'printf'")
		end
		PC += 1
	end
	if PC == 12 then -- .LBB0_8 (extended) 
		registers.a0 = 0
		writei32(memory, registers.s0+124, registers.a0)
		do
			PC = 13
			continue
		end
		PC += 1
	end
	if PC == 13 then -- .LBB0_9
		registers.a1 = readi32(memory, registers.s0+124)
		registers.a0 = 2
		if registers.a0 < registers.a1 then
			do
				PC = 21
				continue
			end
		end
		do
			PC = 14
			continue
		end
		PC += 1
	end
	if PC == 14 then -- .LBB0_10
		registers.a0 = 0
		writei32(memory, registers.s0+120, registers.a0)
		do
			PC = 15
			continue
		end
		PC += 1
	end
	if PC == 15 then -- .LBB0_11
		registers.a1 = readi32(memory, registers.s0+120)
		registers.a0 = 2
		if registers.a0 < registers.a1 then
			do
				PC = 19
				continue
			end
		end
		do
			PC = 16
			continue
		end
		PC += 1
	end
	if PC == 16 then -- .LBB0_12
		registers.a0 = readi32(memory, registers.s0+124)
		registers.a1 = band(lshift(registers.a0, 2), 0xFFFFFFFF)
		registers.a0 = band(lshift(registers.a0, 4), 0xFFFFFFFF)
		registers.a1 = registers.a0 - registers.a1
		registers.a0 = registers.s0 + -120
		registers.a0 = registers.a0 + registers.a1
		registers.a1 = readi32(memory, registers.s0+120)
		registers.a1 = band(lshift(registers.a1, 2), 0xFFFFFFFF)
		registers.a0 = registers.a0 + registers.a1
		registers.a1 = readi32(memory, registers.a0)
		registers.a0 = hi(data[".L.str.1"])
		registers.a0 = registers.a0 + lo(data[".L.str.1"])
		if functions["printf"] then
			functions["printf"]()
			PC = 17
			continue
		else
			error("No bindings for functions 'printf'")
		end
		PC += 1
	end
	if PC == 17 then -- .LBB0_12 (extended) 
		do
			PC = 18
			continue
		end
		PC += 1
	end
	if PC == 18 then -- .LBB0_13
		registers.a0 = readi32(memory, registers.s0+120)
		registers.a0 = registers.a0 + 1
		writei32(memory, registers.s0+120, registers.a0)
		do
			PC = 15
			continue
		end
		PC += 1
	end
	if PC == 19 then -- .LBB0_14
		do
			PC = 20
			continue
		end
		PC += 1
	end
	if PC == 20 then -- .LBB0_15
		registers.a0 = readi32(memory, registers.s0+124)
		registers.a0 = registers.a0 + 1
		writei32(memory, registers.s0+124, registers.a0)
		do
			PC = 13
			continue
		end
		PC += 1
	end
	if PC == 21 then -- .LBB0_16
		registers.a0 = 0
		registers.ra = readi32(memory, registers.sp+-116)
		registers.s0 = readi32(memory, registers.sp+-120)
		registers.sp = registers.sp + 144
		if registers.ra ~= 0 then
			PC = registers.ra
			registers.ra = 0
			continue
		else
			PC = 0
			continue
		end
		PC += 1
	end
	if PC == 22 then -- .Lfunc_end0
		PC += 1
	end
	if PC == 23 then -- .L__const.main.matrix1
		PC += 1
	end
	if PC == 24 then -- .L__const.main.matrix2
		PC += 1
	end
	if PC == 25 then -- .L.str
		PC += 1
	end
	if PC == 26 then -- .L.str.1
		PC += 1
	end
	if (not PC) or PC == 0 or PC > 26 then
		break
	end
end
