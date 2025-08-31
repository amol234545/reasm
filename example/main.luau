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
local function extract_args()
    -- turn arguments from registers a0-a7 into a table
    local args = {}
    for key, value in pairs(registers) do
       	if string.match(key, "^a%d+$") then
      		local index = tonumber(string.match(key, "%d+"))
      		args[index] = value
       	end
    end
    return args
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

    local result = fmt:gsub("%%([%d%.]*[dfs])", function(spec)
        local val = args[arg_index]
        arg_index = arg_index + 1

        if spec:sub(-1) == "d" then
            return string.format("%d", val)
        elseif spec:sub(-1) == "f" then
            return string.format("%"..spec, string.unpack("f", val))
        elseif spec:sub(-1) == "s" then
            return read_string(val)
        else
            return spec
        end
    end)

    return result
end

-- Functions
local functions = {
    ["printf"] = function()
        print(format_string(read_string(registers["a0"]), extract_args()))
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
function init()
	PC = -1
end
function main()
	while PC ~= 0 do
		if (not PC) or PC == 0 or PC > 0 then
			break
		end
	end
end
init()
main()

