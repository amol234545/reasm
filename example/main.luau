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
writestring(memory, 0, "x = %f\n\0")
data[".L.str"] = 0
writestring(memory, 9, "y = %f\n\0")
data[".L.str.1"] = 9
writestring(memory, 18, "z = %f\n\0")
data[".L.str.2"] = 18
while PC ~= 0 do
	if PC == 1 then -- main
		registers.sp = registers.sp + -32
		writei32(memory, registers.sp+28, registers.ra)
		writei32(memory, registers.sp+24, registers.s0)
		registers.s0 = registers.sp + 32
		registers.a0 = 0
		writei32(memory, registers.s0+-28, registers.a0)
		writei32(memory, registers.s0+-12, registers.a0)
		registers.a0 = 266752
		writei32(memory, registers.s0+-16, registers.a0)
		registers.a0 = 268800
		writei32(memory, registers.s0+-20, registers.a0)
		registers.a0 = readi32(memory, registers.s0+-16)
		registers.a1 = readi32(memory, registers.s0+-20)
		if functions["__addsf3"] then
			functions["__addsf3"]()
			PC = 2
			continue
		else
			error("No bindings for functions '__addsf3'")
		end
		PC += 1
	end
	if PC == 2 then -- main (extended) 
		writei32(memory, registers.s0+-24, registers.a0)
		registers.a0 = readi32(memory, registers.s0+-16)
		if functions["__extendsfdf2"] then
			functions["__extendsfdf2"]()
			PC = 3
			continue
		else
			error("No bindings for functions '__extendsfdf2'")
		end
		PC += 1
	end
	if PC == 3 then -- main_end (extended) 
		registers.a2 = registers.a0
		registers.a3 = registers.a1
		registers.a0 = hi(data[".L.str"])
		registers.a0 = registers.a0 + lo(data[".L.str"])
		if functions["printf"] then
			functions["printf"]()
			PC = 4
			continue
		else
			error("No bindings for functions 'printf'")
		end
		PC += 1
	end
	if PC == 4 then -- main_end_end (extended) 
		registers.a0 = readi32(memory, registers.s0+-20)
		if functions["__extendsfdf2"] then
			functions["__extendsfdf2"]()
			PC = 5
			continue
		else
			error("No bindings for functions '__extendsfdf2'")
		end
		PC += 1
	end
	if PC == 5 then -- main_end_end_end (extended) 
		registers.a2 = registers.a0
		registers.a3 = registers.a1
		registers.a0 = hi(data[".L.str.1"])
		registers.a0 = registers.a0 + lo(data[".L.str.1"])
		if functions["printf"] then
			functions["printf"]()
			PC = 6
			continue
		else
			error("No bindings for functions 'printf'")
		end
		PC += 1
	end
	if PC == 6 then -- main_end_end_end_end (extended) 
		registers.a0 = readi32(memory, registers.s0+-24)
		if functions["__extendsfdf2"] then
			functions["__extendsfdf2"]()
			PC = 7
			continue
		else
			error("No bindings for functions '__extendsfdf2'")
		end
		PC += 1
	end
	if PC == 7 then -- main_end_end_end_end_end (extended) 
		registers.a2 = registers.a0
		registers.a3 = registers.a1
		registers.a0 = hi(data[".L.str.2"])
		registers.a0 = registers.a0 + lo(data[".L.str.2"])
		if functions["printf"] then
			functions["printf"]()
			PC = 8
			continue
		else
			error("No bindings for functions 'printf'")
		end
		PC += 1
	end
	if PC == 8 then -- main_end_end_end_end_end_end (extended) 
		registers.a0 = readi32(memory, registers.s0+-28)
		registers.ra = readi32(memory, registers.sp+28)
		registers.s0 = readi32(memory, registers.sp+24)
		registers.sp = registers.sp + 32
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
	if PC == 9 then -- .Lfunc_end0
		PC += 1
	end
	if PC == 10 then -- .L.str
		PC += 1
	end
	if PC == 11 then -- .L.str.1
		PC += 1
	end
	if PC == 12 then -- .L.str.2
		PC += 1
	end
	if (not PC) or PC == 0 or PC > 12 then
		break
	end
end
