-- Compiled from RISC-V assembly.
--- API
local mem = 2048 -- 2KB of RAM
local memory = buffer.create(mem) -- our memory!
local data = {} -- pointers in memory to data, ex: strings
local registers = {
    ["f0"] = 0,
    ["f1"] = 0,
    ["f10"] = 0,
    ["f11"] = 0,
    ["f12"] = 0,
    ["f13"] = 0,
    ["f14"] = 0,
    ["f15"] = 0,
    ["f16"] = 0,
    ["f17"] = 0,
    ["f18"] = 0,
    ["f19"] = 0,
    ["f2"] = 0,
    ["f20"] = 0,
    ["f21"] = 0,
    ["f22"] = 0,
    ["f23"] = 0,
    ["f24"] = 0,
    ["f25"] = 0,
    ["f26"] = 0,
    ["f27"] = 0,
    ["f28"] = 0,
    ["f29"] = 0,
    ["f3"] = 0,
    ["f30"] = 0,
    ["f31"] = 0,
    ["f4"] = 0,
    ["f5"] = 0,
    ["f6"] = 0,
    ["f7"] = 0,
    ["f8"] = 0,
    ["f9"] = 0,
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

}

--- Variables
local PC = 1 -- current position

--- Utility
local function idiv_trunc(a, b)
  if b == 0 then error("division by zero") end
  local q = math.modf(a / b) -- truncated toward zero
  return bit32.band(q, 0xFFFFFFFF) -- keep 32-bit wrap semantics if desired
end
local function float_to_int(f)
    local i = string.unpack("i", string.pack("f", f))
    return i
end
local function int_to_float(i)
    local packed = string.pack("I4", i)
    local f = string.unpack("f", packed)
    return f
end

local function float_to_double(f)
    -- Pack float into 4 bytes
    local packed_f = string.pack("f", f)

    -- Pad with 4 zero bytes to make 8 bytes
    local padded = packed_f .. ("\0\0\0\0")

    -- Unpack as double
    local d = string.unpack("d", padded)
    return d
end

local function double_to_float(d)
    -- Pack double into 8 bytes
    local packed_d = string.pack("d", d)

    -- Take the first 4 bytes (truncate)
    local first4 = packed_d:sub(1, 4)

    -- Unpack as float
    local f = string.unpack("f", first4)
    return f
end
local function two_words_to_double(lowWord, highWord)
    local packed = string.pack("I4I4", lowWord, highWord)
    local d = string.unpack("d", packed)
    return d
end
local function hi(addr)
    return bit32.lshift(bit32.rshift(addr, 12), 12)
end
local function lo(addr)
    return bit32.band(addr, 0xFFF)
end
local function int_to_double(high, low)
    local packed = string.pack("I4I4", high, low)
    local d = string.unpack("d", packed)
    return d
end
local function extract_args()
   return {
       registers.x10,
       registers.x11,
       registers.x12,
       registers.x13,
       registers.x14,
       registers.x15,
       registers.x16,
       registers.x17,
   }
end
local function read_string(startPointer)
    -- read null terminated strings from memory
    local pointer = startPointer
    local str = ""
    local byte
    repeat
        byte = buffer.readbits(memory, pointer * 8, 8)
        if byte == 0 then break end
        str = str .. string.char(byte)
        pointer = pointer + 1
        if pointer >= mem then error("Exceeded buffer size when reading string.") end
    until false
    return str
end
local function format_string(fmt, args)
    -- custom format string because strings are stored as pointers, and floats as ints.
    local arg_index = 1

    local result = fmt:gsub("%%([%d%.]*[dfse])", function(spec)
        local val = args[arg_index]
        arg_index += 1

        if spec:sub(-1) == "d" then
            return string.format("%d", val)
        elseif spec:sub(-1) == "f" then
            arg_index+=1 -- skip for alignment
            local low = args[arg_index]; arg_index+=1;
            local high = args[arg_index]; arg_index+=1;
            local float = int_to_double(high, math.abs(low))

            return string.format("%"..spec, float)
        elseif spec:sub(-1) == "s" then
            return read_string(val)
        elseif spec:sub(-1) == "e" then
            arg_index+=1 -- skip for alignment
            local low = args[arg_index]; arg_index+=1;
            local high = args[arg_index]; arg_index+=1;
            local float = int_to_double(high, low)

            return string.format("%"..spec, float)
        else
            return spec
        end
    end)

    return result
end

-- Functions
local functions = {
    ["printf"] = function()
        local args = extract_args()
        table.remove(args, 1)
        print(format_string(read_string(registers.x10), args))
    end,
    ["memcpy"] = function()
        local dest = registers.x10
        local src = registers.x11
        local count = registers.x12

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

---- Auto generated code starts here
function init()
	writestring(memory, 0, "Float sum: %f\n\0")
	data[".L.str"] = 0
	writestring(memory, 16, "Float product: %f\n\0")
	data[".L.str.1"] = 16
	writestring(memory, 36, "Float division: %f\n\0")
	data[".L.str.2"] = 36
	writestring(memory, 57, "Float difference: %f\n\0")
	data[".L.str.3"] = 57
	writestring(memory, 80, "Double sum: %f\n\0")
	data[".L.str.4"] = 80
	writestring(memory, 97, "Double product: %f\n\0")
	data[".L.str.5"] = 97
	writestring(memory, 118, "Double division: %f\n\0")
	data[".L.str.6"] = 118
	writestring(memory, 140, "Double difference: %f\n\0")
	data[".L.str.7"] = 140
	writestring(memory, 164, "f1 > f2\n\0")
	data[".L.str.8"] = 164
	writestring(memory, 174, "d1 < d2\n\0")
	data[".L.str.9"] = 174
	writestring(memory, 184, "Float infinity: %f\n\0")
	data[".L.str.10"] = 184
	writestring(memory, 205, "Float NaN: %f\n\0")
	data[".L.str.11"] = 205
	writestring(memory, 221, "Double infinity: %f\n\0")
	data[".L.str.12"] = 221
	writestring(memory, 243, "Double NaN: %f\n\0")
	data[".L.str.13"] = 243
	writestring(memory, 260, "Float max: %e\n\0")
	data[".L.str.14"] = 260
	writestring(memory, 276, "Float min: %e\n\0")
	data[".L.str.15"] = 276
	writestring(memory, 292, "Double max: %e\n\0")
	data[".L.str.16"] = 292
	writestring(memory, 309, "Double min: %e\n\0")
	data[".L.str.17"] = 309
	PC = 1
	registers.x2 = (buffer.len(memory) + 326) / 2 -- start at the center after static data
	if registers.x2 >= buffer.len(memory) then error("Not enough memory") end
end
function main()
	while PC ~= 0 do
		if PC == 1 then -- main
			-- addi ([{0 true x2 } {0 true x2 } {0 false -80 }])
			registers.x2 = registers.x2 + -80
			-- sw ([{0 true x1 } {76 true sp }])
			writei32(memory, registers.x2+76, registers.x1)
			-- sw ([{0 true x8 } {72 true sp }])
			writei32(memory, registers.x2+72, registers.x8)
			-- addi ([{0 true x8 } {0 true x2 } {0 false 80 }])
			registers.x8 = registers.x2 + 80
			-- li ([{0 true x10 } {0 false 0 }])
			registers.x10 = 0
			-- sw ([{0 true x10 } {-12 true s0 }])
			writei32(memory, registers.x8+-12, registers.x10)
			-- lui ([{0 true x10 } {0 false 263311 }])
			registers.x10 = lshift(263311, 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false 1475 }])
			registers.x10 = registers.x10 + 1475
			-- sw ([{0 true x10 } {-16 true s0 }])
			writei32(memory, registers.x8+-16, registers.x10)
			-- lui ([{0 true x10 } {0 false 262871 }])
			registers.x10 = lshift(262871, 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false 164 }])
			registers.x10 = registers.x10 + 164
			-- sw ([{0 true x10 } {-20 true s0 }])
			writei32(memory, registers.x8+-20, registers.x10)
			-- lui ([{0 true x10 } {0 false 261948 }])
			registers.x10 = lshift(261948, 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false 131 }])
			registers.x10 = registers.x10 + 131
			-- sw ([{0 true x10 } {-28 true s0 }])
			writei32(memory, registers.x8+-28, registers.x10)
			-- lui ([{0 true x10 } {0 false 75497 }])
			registers.x10 = lshift(75497, 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false 1933 }])
			registers.x10 = registers.x10 + 1933
			-- sw ([{0 true x10 } {-32 true s0 }])
			writei32(memory, registers.x8+-32, registers.x10)
			-- lui ([{0 true x10 } {0 false 262578 }])
			registers.x10 = lshift(262578, 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false 2031 }])
			registers.x10 = registers.x10 + 2031
			-- sw ([{0 true x10 } {-36 true s0 }])
			writei32(memory, registers.x8+-36, registers.x10)
			-- lui ([{0 true x10 } {0 false 645923 }])
			registers.x10 = lshift(645923, 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false -754 }])
			registers.x10 = registers.x10 + -754
			-- sw ([{0 true x10 } {-40 true s0 }])
			writei32(memory, registers.x8+-40, registers.x10)
			-- flw ([{0 true f15 } {-16 true s0 }])
			registers["f15"] = readf32(memory, registers.x8+-16)
			-- flw ([{0 true f14 } {-20 true s0 }])
			registers["f14"] = readf32(memory, registers.x8+-20)
			-- fadd.s ([{0 true f15 } {0 true f15 } {0 true f14 }])
			registers.f15 = registers.f15 + registers.f14
			-- fcvt.d.s ([{0 true f15 } {0 true f15 }])
			registers["f15"] = registers.f15
			-- fsd ([{0 true f15 } {-72 true s0 }])
			writef64(memory, registers.x8+-72, registers.f15)
			-- lw ([{0 true x12 } {-72 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-72)
			-- lw ([{0 true x13 } {-68 true s0 }])
			registers.x13 = readi32(memory, registers.x8+-68)
			-- lui ([{0 true x10 } {0 false .L.str hi}])
			registers.x10 = lshift(hi(data[".L.str"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str lo}])
			registers.x10 = registers.x10 + lo(data[".L.str"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 2
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- main (main)
		if PC == 2 then -- main (extended) 
			-- flw ([{0 true f15 } {-16 true s0 }])
			registers["f15"] = readf32(memory, registers.x8+-16)
			-- flw ([{0 true f14 } {-20 true s0 }])
			registers["f14"] = readf32(memory, registers.x8+-20)
			-- fmul.s ([{0 true f15 } {0 true f15 } {0 true f14 }])
			registers.f15 = registers.f15 * registers.f14
			-- fcvt.d.s ([{0 true f15 } {0 true f15 }])
			registers["f15"] = registers.f15
			-- fsd ([{0 true f15 } {-72 true s0 }])
			writef64(memory, registers.x8+-72, registers.f15)
			-- lw ([{0 true x12 } {-72 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-72)
			-- lw ([{0 true x13 } {-68 true s0 }])
			registers.x13 = readi32(memory, registers.x8+-68)
			-- lui ([{0 true x10 } {0 false .L.str.1 hi}])
			registers.x10 = lshift(hi(data[".L.str.1"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.1 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.1"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 3
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- main_end (main_end)
		if PC == 3 then -- main_end (extended) 
			-- flw ([{0 true f15 } {-16 true s0 }])
			registers["f15"] = readf32(memory, registers.x8+-16)
			-- flw ([{0 true f14 } {-20 true s0 }])
			registers["f14"] = readf32(memory, registers.x8+-20)
			-- fdiv.s ([{0 true f15 } {0 true f15 } {0 true f14 }])
			registers.f15 = idiv_trunc(registers.f15, registers.f14)
			-- fcvt.d.s ([{0 true f15 } {0 true f15 }])
			registers["f15"] = registers.f15
			-- fsd ([{0 true f15 } {-72 true s0 }])
			writef64(memory, registers.x8+-72, registers.f15)
			-- lw ([{0 true x12 } {-72 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-72)
			-- lw ([{0 true x13 } {-68 true s0 }])
			registers.x13 = readi32(memory, registers.x8+-68)
			-- lui ([{0 true x10 } {0 false .L.str.2 hi}])
			registers.x10 = lshift(hi(data[".L.str.2"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.2 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.2"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 4
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- main_end_end (main_end_end)
		if PC == 4 then -- main_end_end (extended) 
			-- flw ([{0 true f15 } {-16 true s0 }])
			registers["f15"] = readf32(memory, registers.x8+-16)
			-- flw ([{0 true f14 } {-20 true s0 }])
			registers["f14"] = readf32(memory, registers.x8+-20)
			-- fsub.s ([{0 true f15 } {0 true f15 } {0 true f14 }])
			registers.f15 = registers.f15 - registers.f14
			-- fcvt.d.s ([{0 true f15 } {0 true f15 }])
			registers["f15"] = registers.f15
			-- fsd ([{0 true f15 } {-72 true s0 }])
			writef64(memory, registers.x8+-72, registers.f15)
			-- lw ([{0 true x12 } {-72 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-72)
			-- lw ([{0 true x13 } {-68 true s0 }])
			registers.x13 = readi32(memory, registers.x8+-68)
			-- lui ([{0 true x10 } {0 false .L.str.3 hi}])
			registers.x10 = lshift(hi(data[".L.str.3"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.3 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.3"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 5
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- main_end_end_end (main_end_end_end)
		if PC == 5 then -- main_end_end_end (extended) 
			-- fld ([{0 true f15 } {-32 true s0 }])
			registers["f15"] = readf64(memory, registers.x8+-32)
			-- fld ([{0 true f14 } {-40 true s0 }])
			registers["f14"] = readf64(memory, registers.x8+-40)
			-- fadd.d ([{0 true f15 } {0 true f15 } {0 true f14 }])
			registers.f15 = registers.f15 + registers.f14
			-- fsd ([{0 true f15 } {-72 true s0 }])
			writef64(memory, registers.x8+-72, registers.f15)
			-- lw ([{0 true x12 } {-72 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-72)
			-- lw ([{0 true x13 } {-68 true s0 }])
			registers.x13 = readi32(memory, registers.x8+-68)
			-- lui ([{0 true x10 } {0 false .L.str.4 hi}])
			registers.x10 = lshift(hi(data[".L.str.4"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.4 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.4"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 6
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- main_end_end_end_end (main_end_end_end_end)
		if PC == 6 then -- main_end_end_end_end (extended) 
			-- fld ([{0 true f15 } {-32 true s0 }])
			registers["f15"] = readf64(memory, registers.x8+-32)
			-- fld ([{0 true f14 } {-40 true s0 }])
			registers["f14"] = readf64(memory, registers.x8+-40)
			-- fmul.d ([{0 true f15 } {0 true f15 } {0 true f14 }])
			registers.f15 = registers.f15 * registers.f14
			-- fsd ([{0 true f15 } {-72 true s0 }])
			writef64(memory, registers.x8+-72, registers.f15)
			-- lw ([{0 true x12 } {-72 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-72)
			-- lw ([{0 true x13 } {-68 true s0 }])
			registers.x13 = readi32(memory, registers.x8+-68)
			-- lui ([{0 true x10 } {0 false .L.str.5 hi}])
			registers.x10 = lshift(hi(data[".L.str.5"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.5 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.5"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 7
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- main_end_end_end_end_end (main_end_end_end_end_end)
		if PC == 7 then -- main_end_end_end_end_end (extended) 
			-- fld ([{0 true f15 } {-32 true s0 }])
			registers["f15"] = readf64(memory, registers.x8+-32)
			-- fld ([{0 true f14 } {-40 true s0 }])
			registers["f14"] = readf64(memory, registers.x8+-40)
			-- fdiv.d ([{0 true f15 } {0 true f15 } {0 true f14 }])
			registers.f15 = idiv_trunc(registers.f15, registers.f14)
			-- fsd ([{0 true f15 } {-72 true s0 }])
			writef64(memory, registers.x8+-72, registers.f15)
			-- lw ([{0 true x12 } {-72 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-72)
			-- lw ([{0 true x13 } {-68 true s0 }])
			registers.x13 = readi32(memory, registers.x8+-68)
			-- lui ([{0 true x10 } {0 false .L.str.6 hi}])
			registers.x10 = lshift(hi(data[".L.str.6"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.6 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.6"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 8
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- main_end_end_end_end_end_end (main_end_end_end_end_end_end)
		if PC == 8 then -- main_end_end_end_end_end_end (extended) 
			-- fld ([{0 true f15 } {-32 true s0 }])
			registers["f15"] = readf64(memory, registers.x8+-32)
			-- fld ([{0 true f14 } {-40 true s0 }])
			registers["f14"] = readf64(memory, registers.x8+-40)
			-- fsub.d ([{0 true f15 } {0 true f15 } {0 true f14 }])
			registers.f15 = registers.f15 - registers.f14
			-- fsd ([{0 true f15 } {-72 true s0 }])
			writef64(memory, registers.x8+-72, registers.f15)
			-- lw ([{0 true x12 } {-72 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-72)
			-- lw ([{0 true x13 } {-68 true s0 }])
			registers.x13 = readi32(memory, registers.x8+-68)
			-- lui ([{0 true x10 } {0 false .L.str.7 hi}])
			registers.x10 = lshift(hi(data[".L.str.7"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.7 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.7"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 9
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- main_end_end_end_end_end_end_end (main_end_end_end_end_end_end_end)
		if PC == 9 then -- main_end_end_end_end_end_end_end (extended) 
			-- flw ([{0 true f14 } {-16 true s0 }])
			registers["f14"] = readf32(memory, registers.x8+-16)
			-- flw ([{0 true f15 } {-20 true s0 }])
			registers["f15"] = readf32(memory, registers.x8+-20)
			-- flt.s ([{0 true x10 } {0 true f15 } {0 true f14 }])
			registers["x10"] = if registers.f15 < registers.f14 then 1 else 0
			-- beqz ([{0 true x10 } {0 false .LBB0_2 }])
			if registers.x10 == 0 then
				do
					PC = 12 -- .LBB0_2
					continue
				end
			end
			-- j ([{0 false .LBB0_1 }])
			do
				PC = 10 -- .LBB0_1
				continue
			end
			PC += 1
		end -- main_end_end_end_end_end_end_end_end (main_end_end_end_end_end_end_end_end)
		if PC == 10 then -- .LBB0_1
			-- lui ([{0 true x10 } {0 false .L.str.8 hi}])
			registers.x10 = lshift(hi(data[".L.str.8"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.8 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.8"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 11
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- .LBB0_1 (.LBB0_1)
		if PC == 11 then -- .LBB0_1 (extended) 
			-- j ([{0 false .LBB0_2 }])
			do
				PC = 12 -- .LBB0_2
				continue
			end
			PC += 1
		end -- .LBB0_1_end (.LBB0_1_end)
		if PC == 12 then -- .LBB0_2
			-- fld ([{0 true f15 } {-32 true s0 }])
			registers["f15"] = readf64(memory, registers.x8+-32)
			-- fld ([{0 true f14 } {-40 true s0 }])
			registers["f14"] = readf64(memory, registers.x8+-40)
			-- flt.d ([{0 true x10 } {0 true f15 } {0 true f14 }])
			registers["x10"] = if registers.f15 < registers.f14 then 1 else 0
			-- beqz ([{0 true x10 } {0 false .LBB0_4 }])
			if registers.x10 == 0 then
				do
					PC = 15 -- .LBB0_4
					continue
				end
			end
			-- j ([{0 false .LBB0_3 }])
			do
				PC = 13 -- .LBB0_3
				continue
			end
			PC += 1
		end -- .LBB0_2 (.LBB0_2)
		if PC == 13 then -- .LBB0_3
			-- lui ([{0 true x10 } {0 false .L.str.9 hi}])
			registers.x10 = lshift(hi(data[".L.str.9"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.9 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.9"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 14
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- .LBB0_3 (.LBB0_3)
		if PC == 14 then -- .LBB0_3 (extended) 
			-- j ([{0 false .LBB0_4 }])
			do
				PC = 15 -- .LBB0_4
				continue
			end
			PC += 1
		end -- .LBB0_3_end (.LBB0_3_end)
		if PC == 15 then -- .LBB0_4
			-- lui ([{0 true x10 } {0 false 522240 }])
			registers.x10 = lshift(522240, 12)
			-- sw ([{0 true x10 } {-44 true s0 }])
			writei32(memory, registers.x8+-44, registers.x10)
			-- lui ([{0 true x10 } {0 false 523264 }])
			registers.x10 = lshift(523264, 12)
			-- sw ([{0 true x10 } {-48 true s0 }])
			writei32(memory, registers.x8+-48, registers.x10)
			-- lui ([{0 true x10 } {0 false 524032 }])
			registers.x10 = lshift(524032, 12)
			-- sw ([{0 true x10 } {-80 true s0 }])
			writei32(memory, registers.x8+-80, registers.x10)
			-- sw ([{0 true x10 } {-52 true s0 }])
			writei32(memory, registers.x8+-52, registers.x10)
			-- li ([{0 true x10 } {0 false 0 }])
			registers.x10 = 0
			-- sw ([{0 true x10 } {-76 true s0 }])
			writei32(memory, registers.x8+-76, registers.x10)
			-- sw ([{0 true x10 } {-56 true s0 }])
			writei32(memory, registers.x8+-56, registers.x10)
			-- lui ([{0 true x11 } {0 false 524160 }])
			registers.x11 = lshift(524160, 12)
			-- sw ([{0 true x11 } {-60 true s0 }])
			writei32(memory, registers.x8+-60, registers.x11)
			-- sw ([{0 true x10 } {-64 true s0 }])
			writei32(memory, registers.x8+-64, registers.x10)
			-- flw ([{0 true f15 } {-44 true s0 }])
			registers["f15"] = readf32(memory, registers.x8+-44)
			-- fcvt.d.s ([{0 true f15 } {0 true f15 }])
			registers["f15"] = registers.f15
			-- fsd ([{0 true f15 } {-72 true s0 }])
			writef64(memory, registers.x8+-72, registers.f15)
			-- lw ([{0 true x12 } {-72 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-72)
			-- lw ([{0 true x13 } {-68 true s0 }])
			registers.x13 = readi32(memory, registers.x8+-68)
			-- lui ([{0 true x10 } {0 false .L.str.10 hi}])
			registers.x10 = lshift(hi(data[".L.str.10"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.10 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.10"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 16
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- .LBB0_4 (.LBB0_4)
		if PC == 16 then -- .LBB0_4 (extended) 
			-- flw ([{0 true f15 } {-48 true s0 }])
			registers["f15"] = readf32(memory, registers.x8+-48)
			-- fcvt.d.s ([{0 true f15 } {0 true f15 }])
			registers["f15"] = registers.f15
			-- fsd ([{0 true f15 } {-72 true s0 }])
			writef64(memory, registers.x8+-72, registers.f15)
			-- lw ([{0 true x12 } {-72 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-72)
			-- lw ([{0 true x13 } {-68 true s0 }])
			registers.x13 = readi32(memory, registers.x8+-68)
			-- lui ([{0 true x10 } {0 false .L.str.11 hi}])
			registers.x10 = lshift(hi(data[".L.str.11"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.11 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.11"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 17
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- .LBB0_4_end (.LBB0_4_end)
		if PC == 17 then -- .LBB0_4_end (extended) 
			-- fld ([{0 true f15 } {-56 true s0 }])
			registers["f15"] = readf64(memory, registers.x8+-56)
			-- fsd ([{0 true f15 } {-72 true s0 }])
			writef64(memory, registers.x8+-72, registers.f15)
			-- lw ([{0 true x12 } {-72 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-72)
			-- lw ([{0 true x13 } {-68 true s0 }])
			registers.x13 = readi32(memory, registers.x8+-68)
			-- lui ([{0 true x10 } {0 false .L.str.12 hi}])
			registers.x10 = lshift(hi(data[".L.str.12"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.12 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.12"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 18
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- .LBB0_4_end_end (.LBB0_4_end_end)
		if PC == 18 then -- .LBB0_4_end_end (extended) 
			-- fld ([{0 true f15 } {-64 true s0 }])
			registers["f15"] = readf64(memory, registers.x8+-64)
			-- fsd ([{0 true f15 } {-72 true s0 }])
			writef64(memory, registers.x8+-72, registers.f15)
			-- lw ([{0 true x12 } {-72 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-72)
			-- lw ([{0 true x13 } {-68 true s0 }])
			registers.x13 = readi32(memory, registers.x8+-68)
			-- lui ([{0 true x10 } {0 false .L.str.13 hi}])
			registers.x10 = lshift(hi(data[".L.str.13"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.13 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.13"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 19
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- .LBB0_4_end_end_end (.LBB0_4_end_end_end)
		if PC == 19 then -- .LBB0_4_end_end_end (extended) 
			-- lui ([{0 true x10 } {0 false .L.str.14 hi}])
			registers.x10 = lshift(hi(data[".L.str.14"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.14 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.14"])
			-- lui ([{0 true x11 } {0 false 294656 }])
			registers.x11 = lshift(294656, 12)
			-- addi ([{0 true x13 } {0 true x11 } {0 false -1 }])
			registers.x13 = registers.x11 + -1
			-- lui ([{0 true x12 } {0 false 917504 }])
			registers.x12 = lshift(917504, 12)
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 20
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- .LBB0_4_end_end_end_end (.LBB0_4_end_end_end_end)
		if PC == 20 then -- .LBB0_4_end_end_end_end (extended) 
			-- lw ([{0 true x12 } {-76 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-76)
			-- lui ([{0 true x10 } {0 false .L.str.15 hi}])
			registers.x10 = lshift(hi(data[".L.str.15"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.15 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.15"])
			-- lui ([{0 true x13 } {0 false 229632 }])
			registers.x13 = lshift(229632, 12)
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 21
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- .LBB0_4_end_end_end_end_end (.LBB0_4_end_end_end_end_end)
		if PC == 21 then -- .LBB0_4_end_end_end_end_end (extended) 
			-- lw ([{0 true x11 } {-80 true s0 }])
			registers.x11 = readi32(memory, registers.x8+-80)
			-- lui ([{0 true x10 } {0 false .L.str.16 hi}])
			registers.x10 = lshift(hi(data[".L.str.16"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.16 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.16"])
			-- addi ([{0 true x13 } {0 true x11 } {0 false -1 }])
			registers.x13 = registers.x11 + -1
			-- li ([{0 true x12 } {0 false -1 }])
			registers.x12 = -1
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 22
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- .LBB0_4_end_end_end_end_end_end (.LBB0_4_end_end_end_end_end_end)
		if PC == 22 then -- .LBB0_4_end_end_end_end_end_end (extended) 
			-- lw ([{0 true x12 } {-76 true s0 }])
			registers.x12 = readi32(memory, registers.x8+-76)
			-- lui ([{0 true x10 } {0 false .L.str.17 hi}])
			registers.x10 = lshift(hi(data[".L.str.17"]), 12)
			-- addi ([{0 true x10 } {0 true x10 } {0 false .L.str.17 lo}])
			registers.x10 = registers.x10 + lo(data[".L.str.17"])
			-- lui ([{0 true x13 } {0 false 256 }])
			registers.x13 = lshift(256, 12)
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 23
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- .LBB0_4_end_end_end_end_end_end_end (.LBB0_4_end_end_end_end_end_end_end)
		if PC == 23 then -- .LBB0_4_end_end_end_end_end_end_end (extended) 
			-- lw ([{0 true x10 } {-76 true s0 }])
			registers.x10 = readi32(memory, registers.x8+-76)
			-- lw ([{0 true x1 } {76 true sp }])
			registers.x1 = readi32(memory, registers.x2+76)
			-- lw ([{0 true x8 } {72 true sp }])
			registers.x8 = readi32(memory, registers.x2+72)
			-- addi ([{0 true x2 } {0 true x2 } {0 false 80 }])
			registers.x2 = registers.x2 + 80
			-- ret ([])
			if registers.x1 ~= 0 then
				PC = registers.x1
				registers.x1 = 0
				continue
			else
				PC = 0
				continue
			end
			PC += 1
		end -- .LBB0_4_end_end_end_end_end_end_end_end (.LBB0_4_end_end_end_end_end_end_end_end)
		if PC == 24 then -- .L.str
			PC += 1
		end -- .L.str (.L.str)
		if PC == 25 then -- .L.str.1
			PC += 1
		end -- .L.str.1 (.L.str.1)
		if PC == 26 then -- .L.str.2
			PC += 1
		end -- .L.str.2 (.L.str.2)
		if PC == 27 then -- .L.str.3
			PC += 1
		end -- .L.str.3 (.L.str.3)
		if PC == 28 then -- .L.str.4
			PC += 1
		end -- .L.str.4 (.L.str.4)
		if PC == 29 then -- .L.str.5
			PC += 1
		end -- .L.str.5 (.L.str.5)
		if PC == 30 then -- .L.str.6
			PC += 1
		end -- .L.str.6 (.L.str.6)
		if PC == 31 then -- .L.str.7
			PC += 1
		end -- .L.str.7 (.L.str.7)
		if PC == 32 then -- .L.str.8
			PC += 1
		end -- .L.str.8 (.L.str.8)
		if PC == 33 then -- .L.str.9
			PC += 1
		end -- .L.str.9 (.L.str.9)
		if PC == 34 then -- .L.str.10
			PC += 1
		end -- .L.str.10 (.L.str.10)
		if PC == 35 then -- .L.str.11
			PC += 1
		end -- .L.str.11 (.L.str.11)
		if PC == 36 then -- .L.str.12
			PC += 1
		end -- .L.str.12 (.L.str.12)
		if PC == 37 then -- .L.str.13
			PC += 1
		end -- .L.str.13 (.L.str.13)
		if PC == 38 then -- .L.str.14
			PC += 1
		end -- .L.str.14 (.L.str.14)
		if PC == 39 then -- .L.str.15
			PC += 1
		end -- .L.str.15 (.L.str.15)
		if PC == 40 then -- .L.str.16
			PC += 1
		end -- .L.str.16 (.L.str.16)
		if PC == 41 then -- .L.str.17
			PC += 1
		end -- .L.str.17 (.L.str.17)
		if (not PC) or PC == 0 or PC > 41 then
			break
		end
	end
end
init()
main()

