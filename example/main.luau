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
	if PC == 1 and not init then -- fib (runtime) 
		registers.sp = registers.sp + -16
		writei32(memory, registers.sp+12, registers.ra)
		writei32(memory, registers.sp+8, registers.s0)
		writei32(memory, registers.sp+4, registers.s1)
		writei32(memory, registers.sp, registers.s2)
		registers.s0 = registers.a0
		registers.s1 = 0
		registers.s2 = 2
		if registers.s0 < registers.s2 then
			do
				PC = labels[".LBB0_2"]
				continue
			end
		end
		PC += 1
	end
	if PC == 2 and not init then -- .LBB0_1 (runtime) 
		registers.a0 = registers.s0 + -1
		if functions["fib"] then
			functions["fib"]()
			PC = 3
			continue
		else
			do
				registers.ra = 3
				PC = labels["fib"]
				continue
			end
		end
		PC += 1
	end
	if PC == 3 and not init then -- .LBB0_1 (extended) 
		registers.s1 = registers.s1 + registers.a0
		registers.s0 = registers.s0 + -2
		if registers.s0 >= registers.s2 then
			do
				PC = labels[".LBB0_1"]
				continue
			end
		end
		PC += 1
	end
	if PC == 4 and not init then -- .LBB0_2 (runtime) 
		registers.a0 = registers.s0 + registers.s1
		registers.ra = readi32(memory, registers.sp+12)
		registers.s0 = readi32(memory, registers.sp+8)
		registers.s1 = readi32(memory, registers.sp+4)
		registers.s2 = readi32(memory, registers.sp)
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
	if PC == 5 and not init then -- .Lfunc_end0 (runtime) 
		PC += 1
	end
	if PC == 6 and not init then -- printFib (runtime) 
		registers.sp = registers.sp + -16
		writei32(memory, registers.sp+12, registers.ra)
		writei32(memory, registers.sp+8, registers.s0)
		writei32(memory, registers.sp+4, registers.s1)
		writei32(memory, registers.sp, registers.s2)
		registers.s0 = registers.a1
		registers.s1 = registers.a0
		registers.s2 = hi(data[".str"])
		registers.s2 = registers.s2 + lo(data[".str"])
		if registers.s0 >= registers.s1 then
			do
				PC = labels[".LBB1_2"]
				continue
			end
		end
		PC += 1
	end
	if PC == 7 and not init then -- .LBB1_1 (runtime) 
		registers.a0 = registers.s0
		if functions["fib"] then
			functions["fib"]()
			PC = 8
			continue
		else
			do
				registers.ra = 8
				PC = labels["fib"]
				continue
			end
		end
		PC += 1
	end
	if PC == 8 and not init then -- .LBB1_1 (extended) 
		registers.a1 = registers.a0
		registers.a0 = registers.s2
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
	if PC == 9 and not init then -- .LBB1_1_end (extended) 
		registers.s0 = registers.s0 + 1
		if registers.s0 < registers.s1 then
			do
				PC = labels[".LBB1_1"]
				continue
			end
		end
		PC += 1
	end
	if PC == 10 and not init then -- .LBB1_2 (runtime) 
		registers.ra = readi32(memory, registers.sp+12)
		registers.s0 = readi32(memory, registers.sp+8)
		registers.s1 = readi32(memory, registers.sp+4)
		registers.s2 = readi32(memory, registers.sp)
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
	if PC == 11 and not init then -- .Lfunc_end1 (runtime) 
		PC += 1
	end
	if PC == 12 and not init then -- main (runtime) 
		registers.sp = registers.sp + -16
		writei32(memory, registers.sp+12, registers.ra)
		registers.a0 = 10
		registers.a1 = 0
		if functions["printFib"] then
			functions["printFib"]()
			PC = 13
			continue
		else
			do
				registers.ra = 13
				PC = labels["printFib"]
				continue
			end
		end
		PC += 1
	end
	if PC == 13 and not init then -- main (extended) 
		registers.a0 = 0
		registers.ra = readi32(memory, registers.sp+12)
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
	if PC == 14 and not init then -- .Lfunc_end2 (runtime) 
		PC += 1
	end
	if init then -- .L.str (initialization)
		writestring(memory, 0, "%d\0")
		data[".str"] = 0
		PC += 1
	end
	if init then -- load label names for quick access
		labels = {
			["fib"] = 1,
			[".LBB0_1"] = 2,
			[".LBB0_1_end"] = 3,
			[".LBB0_2"] = 4,
			[".Lfunc_end0"] = 5,
			["printFib"] = 6,
			[".LBB1_1"] = 7,
			[".LBB1_1_end"] = 8,
			[".LBB1_1_end_end"] = 9,
			[".LBB1_2"] = 10,
			[".Lfunc_end1"] = 11,
			["main"] = 12,
			["main_end"] = 13,
			[".Lfunc_end2"] = 14,
			[".L.str"] = 15,
		}
		PC = labels["main"]
	end
	init = false -- do not initialize again
	if (not PC) or PC == 0 or PC > 15 then
		break
	end
end
