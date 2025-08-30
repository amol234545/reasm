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
	if PC == 1 and not init then -- main (runtime) 
		registers.sp = registers.sp + -16
		writei32(memory, registers.sp+12, registers.ra)
		writei32(memory, registers.sp+8, registers.s0)
		registers.s0 = hi(data[".str"])
		registers.s0 = registers.s0 + lo(data[".str"])
		registers.a1 = 10
		registers.a2 = 20
		registers.a0 = registers.s0
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
	end
	if PC == 2 and not init then -- main (extended) 
		registers.a0 = hi(data[".str.1"])
		registers.a0 = registers.a0 + lo(data[".str.1"])
		registers.a1 = 10
		registers.a2 = 20
		if functions["printf"] then
			functions["printf"]()
			PC = 3
			continue
		else
			do
				registers.ra = 3
				PC = labels["printf"]
				continue
			end
		end
		PC += 1
	end
	if PC == 3 and not init then -- main_end (extended) 
		registers.a0 = hi(data[".str.2"])
		registers.a0 = registers.a0 + lo(data[".str.2"])
		if functions["printf"] then
			functions["printf"]()
			PC = 4
			continue
		else
			do
				registers.ra = 4
				PC = labels["printf"]
				continue
			end
		end
		PC += 1
	end
	if PC == 4 and not init then -- main_end_end (extended) 
		registers.a1 = 15
		registers.a2 = 40
		registers.a0 = registers.s0
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
	end
	if PC == 5 and not init then -- main_end_end_end (extended) 
		registers.a0 = hi(data[".str.3"])
		registers.a0 = registers.a0 + lo(data[".str.3"])
		if functions["printf"] then
			functions["printf"]()
			PC = 6
			continue
		else
			do
				registers.ra = 6
				PC = labels["printf"]
				continue
			end
		end
		PC += 1
	end
	if PC == 6 and not init then -- main_end_end_end_end (extended) 
		registers.s0 = hi(data[".str.4"])
		registers.s0 = registers.s0 + lo(data[".str.4"])
		registers.a2 = 1
		registers.a4 = 1
		registers.a0 = registers.s0
		registers.a1 = 0
		registers.a3 = 0
		if functions["printf"] then
			functions["printf"]()
			PC = 7
			continue
		else
			do
				registers.ra = 7
				PC = labels["printf"]
				continue
			end
		end
		PC += 1
	end
	if PC == 7 and not init then -- main_end_end_end_end_end (extended) 
		registers.a1 = 1
		registers.a2 = 2
		registers.a3 = 1
		registers.a4 = 2
		registers.a0 = registers.s0
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
	end
	if PC == 8 and not init then -- main_end_end_end_end_end_end (extended) 
		registers.a1 = 2
		registers.a2 = 3
		registers.a3 = 2
		registers.a4 = 3
		registers.a0 = registers.s0
		if functions["printf"] then
			functions["printf"]()
			PC = 9
			continue
		else
			do
				registers.ra = 9
				PC = labels["printf"]
				continue
			end
		end
		PC += 1
	end
	if PC == 9 and not init then -- main_end_end_end_end_end_end_end (extended) 
		registers.a1 = 3
		registers.a2 = 4
		registers.a3 = 3
		registers.a4 = 4
		registers.a0 = registers.s0
		if functions["printf"] then
			functions["printf"]()
			PC = 10
			continue
		else
			do
				registers.ra = 10
				PC = labels["printf"]
				continue
			end
		end
		PC += 1
	end
	if PC == 10 and not init then -- main_end_end_end_end_end_end_end_end (extended) 
		registers.a1 = 4
		registers.a2 = 5
		registers.a3 = 4
		registers.a4 = 5
		registers.a0 = registers.s0
		if functions["printf"] then
			functions["printf"]()
			PC = 11
			continue
		else
			do
				registers.ra = 11
				PC = labels["printf"]
				continue
			end
		end
		PC += 1
	end
	if PC == 11 and not init then -- main_end_end_end_end_end_end_end_end_end (extended) 
		registers.a0 = 0
		registers.ra = readi32(memory, registers.sp+12)
		registers.s0 = readi32(memory, registers.sp+8)
		registers.sp = registers.sp + 16
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
	if PC == 12 and not init then -- .Lfunc_end0 (runtime) 
		PC += 1
	end
	if init then -- .L.str (initialization)
		writestring(memory, 0, "a = %d, b = %d\n\0")
		data[".str"] = 0
		PC += 1
	end
	if init then -- .L.str.1 (initialization)
		writestring(memory, 17, "*p = %d, *q = %d\n\0")
		data[".str.1"] = 17
		PC += 1
	end
	if init then -- .L.str.2 (initialization)
		writestring(memory, 36, "After modification:\n\0")
		data[".str.2"] = 36
		PC += 1
	end
	if init then -- .L.str.3 (initialization)
		writestring(memory, 58, "Array elements using pointer:\n\0")
		data[".str.3"] = 58
		PC += 1
	end
	if init then -- .L.str.4 (initialization)
		writestring(memory, 90, "arr[%d] = %d, *(r+%d) = %d\n\0")
		data[".str.4"] = 90
		PC += 1
	end
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
			["main_end_end_end_end_end_end_end_end"] = 9,
			["main_end_end_end_end_end_end_end_end_end"] = 10,
			["main_end_end_end_end_end_end_end_end_end_end"] = 11,
			[".Lfunc_end0"] = 12,
			[".L.str"] = 13,
			[".L.str.1"] = 14,
			[".L.str.2"] = 15,
			[".L.str.3"] = 16,
			[".L.str.4"] = 17,
		}
		PC = labels["main"]
	end
	init = false -- do not initialize again
	if (not PC) or PC == 0 or PC > 17 then
		break
	end
end
