-- Compiled from RISC-V assembly.
--- API
local mem = 2048 -- 2KB of RAM
local memory = buffer.create(mem) -- our memory!
local data = {} -- pointers in memory to data, ex: strings
local registers = {
--{registers here}
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
--{code here}
