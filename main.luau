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
function fclass(x)
    local result = 0

    if x ~= x then
        -- NaN
        if x < 0 then
            result = bit32.bor(result, bit32.lshift(1, 0)) -- -NaN
        else
            result = bit32.bor(result, bit32.lshift(1, 9)) -- +NaN
        end
    elseif x == math.huge then
        result = bit32.bor(result, bit32.lshift(1, 8)) -- +Inf
    elseif x == -math.huge then
        result = bit32.bor(result, bit32.lshift(1, 1)) -- -Inf
    elseif x == 0 then
        if 1/x == math.huge then
            result = bit32.bor(result, bit32.lshift(1, 5)) -- +Zero
        else
            result = bit32.bor(result, bit32.lshift(1, 4)) -- -Zero
        end
    else
        local absx = math.abs(x)
        local min_normal = 2.2250738585072014e-308 -- 2^-1022
        if absx < min_normal then
            if x > 0 then
                result = bit32.bor(result, bit32.lshift(1, 6)) -- +Subnormal
            else
                result = bit32.bor(result, bit32.lshift(1, 3)) -- -Subnormal
            end
        else
            if x > 0 then
                result = bit32.bor(result, bit32.lshift(1, 7)) -- +Normal
            else
                result = bit32.bor(result, bit32.lshift(1, 2)) -- -Normal
            end
        end
    end

    return result
end
local function format_string(fmt, args)
    -- custom format string because strings are stored as pointers, and floats as ints.
    local arg_index = 1

    local result = fmt:gsub("%%([%d%.]*[dfseX])", function(spec)
        local val = args[arg_index]
        arg_index += 1

        if spec:sub(-1) == "d" then
            return string.format("%d", val)
        elseif spec:sub(-1) == "X" then
            return string.format("%X", val)
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
	writestring(memory, 0, "%X\0")
	data[".L.str"] = 0
	PC = 1
	registers.x2 = (buffer.len(memory) + 3) / 2 -- start at the center after static data
	if registers.x2 >= buffer.len(memory) then error("Not enough memory") end
end
function main()
	while PC ~= 0 do
		if PC == 1 then -- main
			-- addi ([{0 true x2 } {0 true x2 } {0 false -32 }])
			registers.x2 = registers.x2 + -32
			-- sw ([{0 true x1 } {28 true sp }])
			writei32(memory, registers.x2+28, registers.x1)
			-- sw ([{0 true x8 } {24 true sp }])
			writei32(memory, registers.x2+24, registers.x8)
			-- addi ([{0 true x8 } {0 true x2 } {0 false 32 }])
			registers.x8 = registers.x2 + 32
			-- li ([{0 true x10 } {0 false 0 }])
			registers.x10 = 0
			-- sw ([{0 true x10 } {-28 true s0 }])
			writei32(memory, registers.x8+-28, registers.x10)
			-- sw ([{0 true x10 } {-12 true s0 }])
			writei32(memory, registers.x8+-12, registers.x10)
			-- li ([{0 true x10 } {0 false 10 }])
			registers.x10 = 10
			-- sw ([{0 true x10 } {-16 true s0 }])
			writei32(memory, registers.x8+-16, registers.x10)
			-- li ([{0 true x10 } {0 false 2 }])
			registers.x10 = 2
			-- sw ([{0 true x10 } {-20 true s0 }])
			writei32(memory, registers.x8+-20, registers.x10)
			-- li ([{0 true x10 } {0 false 34 }])
			registers.x10 = 34
			-- sw ([{0 true x10 } {-24 true s0 }])
			writei32(memory, registers.x8+-24, registers.x10)
			-- lw ([{0 true x10 } {-16 true s0 }])
			registers.x10 = readi32(memory, registers.x8+-16)
			-- lw ([{0 true x11 } {-20 true s0 }])
			registers.x11 = readi32(memory, registers.x8+-20)
			-- mul ([{0 true x10 } {0 true x10 } {0 true x11 }])
			registers.x10 = registers.x10 * registers.x11
			-- lw ([{0 true x11 } {-24 true s0 }])
			registers.x11 = readi32(memory, registers.x8+-24)
			-- add ([{0 true x11 } {0 true x10 } {0 true x11 }])
			registers.x11 = registers.x10 + registers.x11
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
			-- lw ([{0 true x10 } {-28 true s0 }])
			registers.x10 = readi32(memory, registers.x8+-28)
			-- lw ([{0 true x1 } {28 true sp }])
			registers.x1 = readi32(memory, registers.x2+28)
			-- lw ([{0 true x8 } {24 true sp }])
			registers.x8 = readi32(memory, registers.x2+24)
			-- addi ([{0 true x2 } {0 true x2 } {0 false 32 }])
			registers.x2 = registers.x2 + 32
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
		end -- main_end (main_end)
		if PC == 3 then -- .L.str
			PC += 1
		end -- .L.str (.L.str)
		if (not PC) or PC == 0 or PC > 3 then
			break
		end
	end
end
init()
main()

