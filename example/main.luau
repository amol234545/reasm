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
	-- ASM DIRECTIVE: .attribute	4, 16
	-- ASM DIRECTIVE: .attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	-- ASM DIRECTIVE: .file	"main.c"
	-- ASM DIRECTIVE: .text
	-- ASM DIRECTIVE: .globl	main
	-- ASM DIRECTIVE: .p2align	2
	-- ASM DIRECTIVE: .type	main,@function
	-- ASM DIRECTIVE: .type	.L.str,@object
	-- ASM DIRECTIVE: .section	.rodata.str1.1,"aMS",@progbits,1
	writestring(memory, 0, "Fibonacci Sequence:\0")
	data[".L.str"] = 0
	-- ASM DIRECTIVE: .type	.L.str.1,@object
	writestring(memory, 20, "%d\0")
	data[".L.str.1"] = 20
	-- ASM DIRECTIVE: .type	.L.str.2,@object
	writestring(memory, 23, "\n\0")
	data[".L.str.2"] = 23
	-- ASM DIRECTIVE: .ident	"Homebrew clang version 20.1.8"
	-- ASM DIRECTIVE: .section	".note.GNU-stack","",@progbits
	-- ASM DIRECTIVE: .addrsig
	-- ASM DIRECTIVE: .addrsig_sym printf
	PC = 1
end
function main()
	while PC ~= 0 do
		if PC == 1 then -- main
			-- addi ([{0 true sp } {0 true sp } {0 false -64 }])
			registers.sp = registers.sp + -64
			-- sw ([{0 true ra } {60 true sp }])
			writei32(memory, registers.sp+60, registers.ra)
			-- sw ([{0 true s0 } {56 true sp }])
			writei32(memory, registers.sp+56, registers.s0)
			-- addi ([{0 true s0 } {0 true sp } {0 false 64 }])
			registers.s0 = registers.sp + 64
			-- li ([{0 true a0 } {0 false 0 }])
			registers.a0 = 0
			-- sw ([{0 true a0 } {-52 true s0 }])
			writei32(memory, registers.s0+-52, registers.a0)
			-- sw ([{0 true a0 } {-12 true s0 }])
			writei32(memory, registers.s0+-12, registers.a0)
			-- li ([{0 true a1 } {0 false 10 }])
			registers.a1 = 10
			-- sw ([{0 true a1 } {-16 true s0 }])
			writei32(memory, registers.s0+-16, registers.a1)
			-- sw ([{0 true a0 } {-28 true s0 }])
			writei32(memory, registers.s0+-28, registers.a0)
			-- sw ([{0 true a0 } {-32 true s0 }])
			writei32(memory, registers.s0+-32, registers.a0)
			-- sw ([{0 true a0 } {-36 true s0 }])
			writei32(memory, registers.s0+-36, registers.a0)
			-- li ([{0 true a0 } {0 false 1 }])
			registers.a0 = 1
			-- sw ([{0 true a0 } {-40 true s0 }])
			writei32(memory, registers.s0+-40, registers.a0)
			-- lui ([{0 true a0 } {0 false .L.str hi}])
			registers.a0 = hi(data[".L.str"])
			-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str lo}])
			registers.a0 = registers.a0 + lo(data[".L.str"])
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
			-- lw ([{0 true a0 } {-52 true s0 }])
			registers.a0 = readi32(memory, registers.s0+-52)
			-- sw ([{0 true a0 } {-20 true s0 }])
			writei32(memory, registers.s0+-20, registers.a0)
			-- j ([{0 false .LBB0_1 }])
			do
				PC = 3 -- .LBB0_1
				continue
			end
			PC += 1
		end -- main_end (main_end)
		if PC == 3 then -- .LBB0_1
			-- lw ([{0 true a0 } {-20 true s0 }])
			registers.a0 = readi32(memory, registers.s0+-20)
			-- lw ([{0 true a1 } {-16 true s0 }])
			registers.a1 = readi32(memory, registers.s0+-16)
			-- bge ([{0 true a0 } {0 true a1 } {0 false .LBB0_7 }])
			if registers.a0 >= registers.a1 then
				do
					PC = 10 -- .LBB0_7
					continue
				end
			end
			-- j ([{0 false .LBB0_2 }])
			do
				PC = 4 -- .LBB0_2
				continue
			end
			PC += 1
		end -- .LBB0_1 (.LBB0_1)
		if PC == 4 then -- .LBB0_2
			-- lw ([{0 true a1 } {-20 true s0 }])
			registers.a1 = readi32(memory, registers.s0+-20)
			-- li ([{0 true a0 } {0 false 1 }])
			registers.a0 = 1
			-- blt ([{0 true a0 } {0 true a1 } {0 false .LBB0_4 }])
			if registers.a0 < registers.a1 then
				do
					PC = 6 -- .LBB0_4
					continue
				end
			end
			-- j ([{0 false .LBB0_3 }])
			do
				PC = 5 -- .LBB0_3
				continue
			end
			PC += 1
		end -- .LBB0_2 (.LBB0_2)
		if PC == 5 then -- .LBB0_3
			-- lw ([{0 true a1 } {-20 true s0 }])
			registers.a1 = readi32(memory, registers.s0+-20)
			-- srai ([{0 true a0 } {0 true a1 } {0 false 31 }])
			registers.a0 = band(arshift(registers.a1, 31), 0xFFFFFFFF)
			-- sw ([{0 true a1 } {-48 true s0 }])
			writei32(memory, registers.s0+-48, registers.a1)
			-- sw ([{0 true a0 } {-44 true s0 }])
			writei32(memory, registers.s0+-44, registers.a0)
			-- j ([{0 false .LBB0_5 }])
			do
				PC = 7 -- .LBB0_5
				continue
			end
			PC += 1
		end -- .LBB0_3 (.LBB0_3)
		if PC == 6 then -- .LBB0_4
			-- lw ([{0 true a2 } {-32 true s0 }])
			registers.a2 = readi32(memory, registers.s0+-32)
			-- lw ([{0 true a0 } {-28 true s0 }])
			registers.a0 = readi32(memory, registers.s0+-28)
			-- lw ([{0 true a1 } {-40 true s0 }])
			registers.a1 = readi32(memory, registers.s0+-40)
			-- lw ([{0 true a3 } {-36 true s0 }])
			registers.a3 = readi32(memory, registers.s0+-36)
			-- add ([{0 true a0 } {0 true a0 } {0 true a3 }])
			registers.a0 = registers.a0 + registers.a3
			-- add ([{0 true a1 } {0 true a2 } {0 true a1 }])
			registers.a1 = registers.a2 + registers.a1
			-- sltu ([{0 true a2 } {0 true a1 } {0 true a2 }])
			registers.a2 = if (registers.a1 < registers.a2) then 1 else 0
			-- add ([{0 true a0 } {0 true a0 } {0 true a2 }])
			registers.a0 = registers.a0 + registers.a2
			-- sw ([{0 true a1 } {-48 true s0 }])
			writei32(memory, registers.s0+-48, registers.a1)
			-- sw ([{0 true a0 } {-44 true s0 }])
			writei32(memory, registers.s0+-44, registers.a0)
			-- lw ([{0 true a0 } {-40 true s0 }])
			registers.a0 = readi32(memory, registers.s0+-40)
			-- lw ([{0 true a1 } {-36 true s0 }])
			registers.a1 = readi32(memory, registers.s0+-36)
			-- sw ([{0 true a1 } {-28 true s0 }])
			writei32(memory, registers.s0+-28, registers.a1)
			-- sw ([{0 true a0 } {-32 true s0 }])
			writei32(memory, registers.s0+-32, registers.a0)
			-- lw ([{0 true a0 } {-48 true s0 }])
			registers.a0 = readi32(memory, registers.s0+-48)
			-- lw ([{0 true a1 } {-44 true s0 }])
			registers.a1 = readi32(memory, registers.s0+-44)
			-- sw ([{0 true a1 } {-36 true s0 }])
			writei32(memory, registers.s0+-36, registers.a1)
			-- sw ([{0 true a0 } {-40 true s0 }])
			writei32(memory, registers.s0+-40, registers.a0)
			-- j ([{0 false .LBB0_5 }])
			do
				PC = 7 -- .LBB0_5
				continue
			end
			PC += 1
		end -- .LBB0_4 (.LBB0_4)
		if PC == 7 then -- .LBB0_5
			-- lw ([{0 true a1 } {-48 true s0 }])
			registers.a1 = readi32(memory, registers.s0+-48)
			-- lui ([{0 true a0 } {0 false .L.str.1 hi}])
			registers.a0 = hi(data[".L.str.1"])
			-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str.1 lo}])
			registers.a0 = registers.a0 + lo(data[".L.str.1"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 8
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- .LBB0_5 (.LBB0_5)
		if PC == 8 then -- .LBB0_5 (extended) 
			-- j ([{0 false .LBB0_6 }])
			do
				PC = 9 -- .LBB0_6
				continue
			end
			PC += 1
		end -- .LBB0_5_end (.LBB0_5_end)
		if PC == 9 then -- .LBB0_6
			-- lw ([{0 true a0 } {-20 true s0 }])
			registers.a0 = readi32(memory, registers.s0+-20)
			-- addi ([{0 true a0 } {0 true a0 } {0 false 1 }])
			registers.a0 = registers.a0 + 1
			-- sw ([{0 true a0 } {-20 true s0 }])
			writei32(memory, registers.s0+-20, registers.a0)
			-- j ([{0 false .LBB0_1 }])
			do
				PC = 3 -- .LBB0_1
				continue
			end
			PC += 1
		end -- .LBB0_6 (.LBB0_6)
		if PC == 10 then -- .LBB0_7
			-- lui ([{0 true a0 } {0 false .L.str.2 hi}])
			registers.a0 = hi(data[".L.str.2"])
			-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str.2 lo}])
			registers.a0 = registers.a0 + lo(data[".L.str.2"])
			-- call ([{0 false printf }])
			if functions["printf"] then
				functions["printf"]()
				PC = 11
				continue
			else
				error("No bindings for functions 'printf'")
			end
			PC += 1
		end -- .LBB0_7 (.LBB0_7)
		if PC == 11 then -- .LBB0_7 (extended) 
			-- li ([{0 true a0 } {0 false 0 }])
			registers.a0 = 0
			-- lw ([{0 true ra } {60 true sp }])
			registers.ra = readi32(memory, registers.sp+60)
			-- lw ([{0 true s0 } {56 true sp }])
			registers.s0 = readi32(memory, registers.sp+56)
			-- addi ([{0 true sp } {0 true sp } {0 false 64 }])
			registers.sp = registers.sp + 64
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
		end -- .LBB0_7_end (.LBB0_7_end)
		if PC == 12 then -- .Lfunc_end0
			PC += 1
		end -- .Lfunc_end0 (.Lfunc_end0)
		if PC == 13 then -- .L.str
			PC += 1
		end -- .L.str (.L.str)
		if PC == 14 then -- .L.str.1
			PC += 1
		end -- .L.str.1 (.L.str.1)
		if PC == 15 then -- .L.str.2
			PC += 1
		end -- .L.str.2 (.L.str.2)
		if (not PC) or PC == 0 or PC > 15 then
			break
		end
	end
end
init()
main()

