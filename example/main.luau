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
-- ASM DIRECTIVE: .attribute	4, 16
-- ASM DIRECTIVE: .attribute	5, "rv32i2p1_m2p0_zmmul1p0"
-- ASM DIRECTIVE: .file	"main.cpp"
-- ASM DIRECTIVE: .text
PC = 1
-- ASM DIRECTIVE: .p2align	2
-- ASM DIRECTIVE: .type	main,@function
-- ASM DIRECTIVE: .cfi_startproc
-- ASM DIRECTIVE: .cfi_def_cfa_offset 32
-- ASM DIRECTIVE: .cfi_offset ra, -4
-- ASM DIRECTIVE: .cfi_offset s0, -8
-- ASM DIRECTIVE: .cfi_def_cfa s0, 0
-- ASM DIRECTIVE: .cfi_def_cfa sp, 32
-- ASM DIRECTIVE: .cfi_restore ra
-- ASM DIRECTIVE: .cfi_restore s0
-- ASM DIRECTIVE: .cfi_def_cfa_offset 0
-- ASM DIRECTIVE: .cfi_endproc
-- ASM DIRECTIVE: .section	.text._ZN11BankAccountC2EPKci,"axG",@progbits,_ZN11BankAccountC2EPKci,comdat
-- ASM DIRECTIVE: .weak	_ZN11BankAccountC2EPKci
-- ASM DIRECTIVE: .p2align	2
-- ASM DIRECTIVE: .type	_ZN11BankAccountC2EPKci,@function
-- ASM DIRECTIVE: .section	.text._ZNK11BankAccount11showBalanceEv,"axG",@progbits,_ZNK11BankAccount11showBalanceEv,comdat
-- ASM DIRECTIVE: .weak	_ZNK11BankAccount11showBalanceEv
-- ASM DIRECTIVE: .p2align	2
-- ASM DIRECTIVE: .type	_ZNK11BankAccount11showBalanceEv,@function
-- ASM DIRECTIVE: .cfi_startproc
-- ASM DIRECTIVE: .cfi_def_cfa_offset 16
-- ASM DIRECTIVE: .cfi_offset ra, -4
-- ASM DIRECTIVE: .cfi_offset s0, -8
-- ASM DIRECTIVE: .cfi_def_cfa s0, 0
-- ASM DIRECTIVE: .cfi_def_cfa sp, 16
-- ASM DIRECTIVE: .cfi_restore ra
-- ASM DIRECTIVE: .cfi_restore s0
-- ASM DIRECTIVE: .cfi_def_cfa_offset 0
-- ASM DIRECTIVE: .cfi_endproc
-- ASM DIRECTIVE: .section	.text._ZN11BankAccount7depositEi,"axG",@progbits,_ZN11BankAccount7depositEi,comdat
-- ASM DIRECTIVE: .weak	_ZN11BankAccount7depositEi
-- ASM DIRECTIVE: .p2align	2
-- ASM DIRECTIVE: .type	_ZN11BankAccount7depositEi,@function
-- ASM DIRECTIVE: .cfi_startproc
-- ASM DIRECTIVE: .cfi_def_cfa_offset 32
-- ASM DIRECTIVE: .cfi_offset ra, -4
-- ASM DIRECTIVE: .cfi_offset s0, -8
-- ASM DIRECTIVE: .cfi_def_cfa s0, 0
-- ASM DIRECTIVE: .cfi_def_cfa sp, 32
-- ASM DIRECTIVE: .cfi_restore ra
-- ASM DIRECTIVE: .cfi_restore s0
-- ASM DIRECTIVE: .cfi_def_cfa_offset 0
-- ASM DIRECTIVE: .cfi_endproc
-- ASM DIRECTIVE: .section	.text._ZN11BankAccount8withdrawEi,"axG",@progbits,_ZN11BankAccount8withdrawEi,comdat
-- ASM DIRECTIVE: .weak	_ZN11BankAccount8withdrawEi
-- ASM DIRECTIVE: .p2align	2
-- ASM DIRECTIVE: .type	_ZN11BankAccount8withdrawEi,@function
-- ASM DIRECTIVE: .cfi_startproc
-- ASM DIRECTIVE: .cfi_def_cfa_offset 32
-- ASM DIRECTIVE: .cfi_offset ra, -4
-- ASM DIRECTIVE: .cfi_offset s0, -8
-- ASM DIRECTIVE: .cfi_def_cfa s0, 0
-- ASM DIRECTIVE: .cfi_def_cfa sp, 32
-- ASM DIRECTIVE: .cfi_restore ra
-- ASM DIRECTIVE: .cfi_restore s0
-- ASM DIRECTIVE: .cfi_def_cfa_offset 0
-- ASM DIRECTIVE: .cfi_endproc
-- ASM DIRECTIVE: .type	.L.str,@object
-- ASM DIRECTIVE: .section	.rodata.str1.1,"aMS",@progbits,1
writestring(memory, 0, "Alice\0")
data[".L.str"] = 0
-- ASM DIRECTIVE: .type	.L.str.1,@object
writestring(memory, 6, "%s's balance: $%d\0")
data[".L.str.1"] = 6
-- ASM DIRECTIVE: .type	.L.str.2,@object
writestring(memory, 24, "Deposited: $%d\0")
data[".L.str.2"] = 24
-- ASM DIRECTIVE: .type	.L.str.3,@object
writestring(memory, 39, "Invalid deposit amount.\0")
data[".L.str.3"] = 39
-- ASM DIRECTIVE: .type	.L.str.4,@object
writestring(memory, 63, "Withdrew: $%d\0")
data[".L.str.4"] = 63
-- ASM DIRECTIVE: .type	.L.str.5,@object
writestring(memory, 77, "Insufficient funds or invalid amount.\0")
data[".L.str.5"] = 77
-- ASM DIRECTIVE: .ident	"Homebrew clang version 20.1.8"
-- ASM DIRECTIVE: .section	".note.GNU-stack","",@progbits
-- ASM DIRECTIVE: .addrsig
-- ASM DIRECTIVE: .addrsig_sym _ZNK11BankAccount11showBalanceEv
-- ASM DIRECTIVE: .addrsig_sym _ZN11BankAccount7depositEi
-- ASM DIRECTIVE: .addrsig_sym _ZN11BankAccount8withdrawEi
-- ASM DIRECTIVE: .addrsig_sym printf
while PC ~= 0 do
	if PC == 1 then -- main
		-- addi ([{0 true sp } {0 true sp } {0 false -32 }])
		registers.sp = registers.sp + -32
		-- sw ([{0 true ra } {28 true sp }])
		writei32(memory, registers.sp+28, registers.ra)
		-- sw ([{0 true s0 } {24 true sp }])
		writei32(memory, registers.sp+24, registers.s0)
		-- addi ([{0 true s0 } {0 true sp } {0 false 32 }])
		registers.s0 = registers.sp + 32
		-- li ([{0 true a0 } {0 false 0 }])
		registers.a0 = 0
		-- sw ([{0 true a0 } {-24 true s0 }])
		writei32(memory, registers.s0+-24, registers.a0)
		-- sw ([{0 true a0 } {-12 true s0 }])
		writei32(memory, registers.s0+-12, registers.a0)
		-- lui ([{0 true a1 } {0 false .L.str hi}])
		registers.a1 = hi(data[".L.str"])
		-- addi ([{0 true a1 } {0 true a1 } {0 false .L.str lo}])
		registers.a1 = registers.a1 + lo(data[".L.str"])
		-- addi ([{0 true a0 } {0 true s0 } {0 false -20 }])
		registers.a0 = registers.s0 + -20
		-- sw ([{0 true a0 } {-28 true s0 }])
		writei32(memory, registers.s0+-28, registers.a0)
		-- li ([{0 true a2 } {0 false 1000 }])
		registers.a2 = 1000
		-- call ([{0 false _ZN11BankAccountC2EPKci }])
		if functions["_ZN11BankAccountC2EPKci"] then
			functions["_ZN11BankAccountC2EPKci"]()
			PC = 2
			continue
		else
			do
				registers.ra = 2
				PC = 8 -- _ZN11BankAccountC2EPKci
				continue
			end
		end
		PC += 1
	end -- main (main)
	if PC == 2 then -- main (extended) 
		-- lw ([{0 true a0 } {-28 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-28)
		-- call ([{0 false _ZNK11BankAccount11showBalanceEv }])
		if functions["_ZNK11BankAccount11showBalanceEv"] then
			functions["_ZNK11BankAccount11showBalanceEv"]()
			PC = 3
			continue
		else
			do
				registers.ra = 3
				PC = 10 -- _ZNK11BankAccount11showBalanceEv
				continue
			end
		end
		PC += 1
	end -- main_end (main_end)
	if PC == 3 then -- main_end (extended) 
		-- lw ([{0 true a0 } {-28 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-28)
		-- li ([{0 true a1 } {0 false 250 }])
		registers.a1 = 250
		-- call ([{0 false _ZN11BankAccount7depositEi }])
		if functions["_ZN11BankAccount7depositEi"] then
			functions["_ZN11BankAccount7depositEi"]()
			PC = 4
			continue
		else
			do
				registers.ra = 4
				PC = 13 -- _ZN11BankAccount7depositEi
				continue
			end
		end
		PC += 1
	end -- main_end_end (main_end_end)
	if PC == 4 then -- main_end_end (extended) 
		-- lw ([{0 true a0 } {-28 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-28)
		-- li ([{0 true a1 } {0 false 500 }])
		registers.a1 = 500
		-- call ([{0 false _ZN11BankAccount8withdrawEi }])
		if functions["_ZN11BankAccount8withdrawEi"] then
			functions["_ZN11BankAccount8withdrawEi"]()
			PC = 5
			continue
		else
			do
				registers.ra = 5
				PC = 20 -- _ZN11BankAccount8withdrawEi
				continue
			end
		end
		PC += 1
	end -- main_end_end_end (main_end_end_end)
	if PC == 5 then -- main_end_end_end (extended) 
		-- lw ([{0 true a0 } {-28 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-28)
		-- call ([{0 false _ZNK11BankAccount11showBalanceEv }])
		if functions["_ZNK11BankAccount11showBalanceEv"] then
			functions["_ZNK11BankAccount11showBalanceEv"]()
			PC = 6
			continue
		else
			do
				registers.ra = 6
				PC = 10 -- _ZNK11BankAccount11showBalanceEv
				continue
			end
		end
		PC += 1
	end -- main_end_end_end_end (main_end_end_end_end)
	if PC == 6 then -- main_end_end_end_end (extended) 
		-- lw ([{0 true a0 } {-24 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-24)
		-- lw ([{0 true ra } {28 true sp }])
		registers.ra = readi32(memory, registers.sp+28)
		-- lw ([{0 true s0 } {24 true sp }])
		registers.s0 = readi32(memory, registers.sp+24)
		-- addi ([{0 true sp } {0 true sp } {0 false 32 }])
		registers.sp = registers.sp + 32
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
	end -- main_end_end_end_end_end (main_end_end_end_end_end)
	if PC == 7 then -- .Lfunc_end0
		PC += 1
	end -- .Lfunc_end0 (.Lfunc_end0)
	if PC == 8 then -- _ZN11BankAccountC2EPKci
		-- addi ([{0 true sp } {0 true sp } {0 false -32 }])
		registers.sp = registers.sp + -32
		-- sw ([{0 true ra } {28 true sp }])
		writei32(memory, registers.sp+28, registers.ra)
		-- sw ([{0 true s0 } {24 true sp }])
		writei32(memory, registers.sp+24, registers.s0)
		-- addi ([{0 true s0 } {0 true sp } {0 false 32 }])
		registers.s0 = registers.sp + 32
		-- sw ([{0 true a0 } {-12 true s0 }])
		writei32(memory, registers.s0+-12, registers.a0)
		-- sw ([{0 true a1 } {-16 true s0 }])
		writei32(memory, registers.s0+-16, registers.a1)
		-- sw ([{0 true a2 } {-20 true s0 }])
		writei32(memory, registers.s0+-20, registers.a2)
		-- lw ([{0 true a1 } {-12 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-12)
		-- lw ([{0 true a0 } {-16 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-16)
		-- sw ([{0 true a0 } {0 true a1 }])
		writei32(memory, registers.a1, registers.a0)
		-- lw ([{0 true a0 } {-20 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-20)
		-- sw ([{0 true a0 } {4 true a1 }])
		writei32(memory, registers.a1+4, registers.a0)
		-- lw ([{0 true ra } {28 true sp }])
		registers.ra = readi32(memory, registers.sp+28)
		-- lw ([{0 true s0 } {24 true sp }])
		registers.s0 = readi32(memory, registers.sp+24)
		-- addi ([{0 true sp } {0 true sp } {0 false 32 }])
		registers.sp = registers.sp + 32
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
	end -- _ZN11BankAccountC2EPKci (_ZN11BankAccountC2EPKci)
	if PC == 9 then -- .Lfunc_end1
		PC += 1
	end -- .Lfunc_end1 (.Lfunc_end1)
	if PC == 10 then -- _ZNK11BankAccount11showBalanceEv
		-- addi ([{0 true sp } {0 true sp } {0 false -16 }])
		registers.sp = registers.sp + -16
		-- sw ([{0 true ra } {12 true sp }])
		writei32(memory, registers.sp+12, registers.ra)
		-- sw ([{0 true s0 } {8 true sp }])
		writei32(memory, registers.sp+8, registers.s0)
		-- addi ([{0 true s0 } {0 true sp } {0 false 16 }])
		registers.s0 = registers.sp + 16
		-- sw ([{0 true a0 } {-12 true s0 }])
		writei32(memory, registers.s0+-12, registers.a0)
		-- lw ([{0 true a0 } {-12 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-12)
		-- lw ([{0 true a1 } {0 true a0 }])
		registers.a1 = readi32(memory, registers.a0)
		-- lw ([{0 true a2 } {4 true a0 }])
		registers.a2 = readi32(memory, registers.a0+4)
		-- lui ([{0 true a0 } {0 false .L.str.1 hi}])
		registers.a0 = hi(data[".L.str.1"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str.1 lo}])
		registers.a0 = registers.a0 + lo(data[".L.str.1"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 11
			continue
		else
			error("No bindings for functions 'printf'")
		end
		PC += 1
	end -- _ZNK11BankAccount11showBalanceEv (_ZNK11BankAccount11showBalanceEv)
	if PC == 11 then -- _ZNK11BankAccount11showBalanceEv (extended) 
		-- lw ([{0 true ra } {12 true sp }])
		registers.ra = readi32(memory, registers.sp+12)
		-- lw ([{0 true s0 } {8 true sp }])
		registers.s0 = readi32(memory, registers.sp+8)
		-- addi ([{0 true sp } {0 true sp } {0 false 16 }])
		registers.sp = registers.sp + 16
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
	end -- _ZNK11BankAccount11showBalanceEv_end (_ZNK11BankAccount11showBalanceEv_end)
	if PC == 12 then -- .Lfunc_end2
		PC += 1
	end -- .Lfunc_end2 (.Lfunc_end2)
	if PC == 13 then -- _ZN11BankAccount7depositEi
		-- addi ([{0 true sp } {0 true sp } {0 false -32 }])
		registers.sp = registers.sp + -32
		-- sw ([{0 true ra } {28 true sp }])
		writei32(memory, registers.sp+28, registers.ra)
		-- sw ([{0 true s0 } {24 true sp }])
		writei32(memory, registers.sp+24, registers.s0)
		-- addi ([{0 true s0 } {0 true sp } {0 false 32 }])
		registers.s0 = registers.sp + 32
		-- sw ([{0 true a0 } {-12 true s0 }])
		writei32(memory, registers.s0+-12, registers.a0)
		-- sw ([{0 true a1 } {-16 true s0 }])
		writei32(memory, registers.s0+-16, registers.a1)
		-- lw ([{0 true a0 } {-12 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-12)
		-- sw ([{0 true a0 } {-20 true s0 }])
		writei32(memory, registers.s0+-20, registers.a0)
		-- lw ([{0 true a1 } {-16 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-16)
		-- li ([{0 true a0 } {0 false 0 }])
		registers.a0 = 0
		-- bge ([{0 true a0 } {0 true a1 } {0 false .LBB3_2 }])
		if registers.a0 >= registers.a1 then
			do
				PC = 16 -- .LBB3_2
				continue
			end
		end
		-- j ([{0 false .LBB3_1 }])
		do
			PC = 14 -- .LBB3_1
			continue
		end
		PC += 1
	end -- _ZN11BankAccount7depositEi (_ZN11BankAccount7depositEi)
	if PC == 14 then -- .LBB3_1
		-- lw ([{0 true a1 } {-20 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-20)
		-- lw ([{0 true a2 } {-16 true s0 }])
		registers.a2 = readi32(memory, registers.s0+-16)
		-- lw ([{0 true a0 } {4 true a1 }])
		registers.a0 = readi32(memory, registers.a1+4)
		-- add ([{0 true a0 } {0 true a0 } {0 true a2 }])
		registers.a0 = registers.a0 + registers.a2
		-- sw ([{0 true a0 } {4 true a1 }])
		writei32(memory, registers.a1+4, registers.a0)
		-- lw ([{0 true a1 } {-16 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-16)
		-- lui ([{0 true a0 } {0 false .L.str.2 hi}])
		registers.a0 = hi(data[".L.str.2"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str.2 lo}])
		registers.a0 = registers.a0 + lo(data[".L.str.2"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 15
			continue
		else
			error("No bindings for functions 'printf'")
		end
		PC += 1
	end -- .LBB3_1 (.LBB3_1)
	if PC == 15 then -- .LBB3_1 (extended) 
		-- j ([{0 false .LBB3_3 }])
		do
			PC = 18 -- .LBB3_3
			continue
		end
		PC += 1
	end -- .LBB3_1_end (.LBB3_1_end)
	if PC == 16 then -- .LBB3_2
		-- lui ([{0 true a0 } {0 false .L.str.3 hi}])
		registers.a0 = hi(data[".L.str.3"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str.3 lo}])
		registers.a0 = registers.a0 + lo(data[".L.str.3"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 17
			continue
		else
			error("No bindings for functions 'printf'")
		end
		PC += 1
	end -- .LBB3_2 (.LBB3_2)
	if PC == 17 then -- .LBB3_2 (extended) 
		-- j ([{0 false .LBB3_3 }])
		do
			PC = 18 -- .LBB3_3
			continue
		end
		PC += 1
	end -- .LBB3_2_end (.LBB3_2_end)
	if PC == 18 then -- .LBB3_3
		-- lw ([{0 true ra } {28 true sp }])
		registers.ra = readi32(memory, registers.sp+28)
		-- lw ([{0 true s0 } {24 true sp }])
		registers.s0 = readi32(memory, registers.sp+24)
		-- addi ([{0 true sp } {0 true sp } {0 false 32 }])
		registers.sp = registers.sp + 32
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
	end -- .LBB3_3 (.LBB3_3)
	if PC == 19 then -- .Lfunc_end3
		PC += 1
	end -- .Lfunc_end3 (.Lfunc_end3)
	if PC == 20 then -- _ZN11BankAccount8withdrawEi
		-- addi ([{0 true sp } {0 true sp } {0 false -32 }])
		registers.sp = registers.sp + -32
		-- sw ([{0 true ra } {28 true sp }])
		writei32(memory, registers.sp+28, registers.ra)
		-- sw ([{0 true s0 } {24 true sp }])
		writei32(memory, registers.sp+24, registers.s0)
		-- addi ([{0 true s0 } {0 true sp } {0 false 32 }])
		registers.s0 = registers.sp + 32
		-- sw ([{0 true a0 } {-12 true s0 }])
		writei32(memory, registers.s0+-12, registers.a0)
		-- sw ([{0 true a1 } {-16 true s0 }])
		writei32(memory, registers.s0+-16, registers.a1)
		-- lw ([{0 true a0 } {-12 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-12)
		-- sw ([{0 true a0 } {-20 true s0 }])
		writei32(memory, registers.s0+-20, registers.a0)
		-- lw ([{0 true a1 } {-16 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-16)
		-- li ([{0 true a0 } {0 false 0 }])
		registers.a0 = 0
		-- bge ([{0 true a0 } {0 true a1 } {0 false .LBB4_3 }])
		if registers.a0 >= registers.a1 then
			do
				PC = 24 -- .LBB4_3
				continue
			end
		end
		-- j ([{0 false .LBB4_1 }])
		do
			PC = 21 -- .LBB4_1
			continue
		end
		PC += 1
	end -- _ZN11BankAccount8withdrawEi (_ZN11BankAccount8withdrawEi)
	if PC == 21 then -- .LBB4_1
		-- lw ([{0 true a0 } {-20 true s0 }])
		registers.a0 = readi32(memory, registers.s0+-20)
		-- lw ([{0 true a1 } {-16 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-16)
		-- lw ([{0 true a0 } {4 true a0 }])
		registers.a0 = readi32(memory, registers.a0+4)
		-- blt ([{0 true a0 } {0 true a1 } {0 false .LBB4_3 }])
		if registers.a0 < registers.a1 then
			do
				PC = 24 -- .LBB4_3
				continue
			end
		end
		-- j ([{0 false .LBB4_2 }])
		do
			PC = 22 -- .LBB4_2
			continue
		end
		PC += 1
	end -- .LBB4_1 (.LBB4_1)
	if PC == 22 then -- .LBB4_2
		-- lw ([{0 true a1 } {-20 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-20)
		-- lw ([{0 true a2 } {-16 true s0 }])
		registers.a2 = readi32(memory, registers.s0+-16)
		-- lw ([{0 true a0 } {4 true a1 }])
		registers.a0 = readi32(memory, registers.a1+4)
		-- sub ([{0 true a0 } {0 true a0 } {0 true a2 }])
		registers.a0 = registers.a0 - registers.a2
		-- sw ([{0 true a0 } {4 true a1 }])
		writei32(memory, registers.a1+4, registers.a0)
		-- lw ([{0 true a1 } {-16 true s0 }])
		registers.a1 = readi32(memory, registers.s0+-16)
		-- lui ([{0 true a0 } {0 false .L.str.4 hi}])
		registers.a0 = hi(data[".L.str.4"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str.4 lo}])
		registers.a0 = registers.a0 + lo(data[".L.str.4"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 23
			continue
		else
			error("No bindings for functions 'printf'")
		end
		PC += 1
	end -- .LBB4_2 (.LBB4_2)
	if PC == 23 then -- .LBB4_2 (extended) 
		-- j ([{0 false .LBB4_4 }])
		do
			PC = 26 -- .LBB4_4
			continue
		end
		PC += 1
	end -- .LBB4_2_end (.LBB4_2_end)
	if PC == 24 then -- .LBB4_3
		-- lui ([{0 true a0 } {0 false .L.str.5 hi}])
		registers.a0 = hi(data[".L.str.5"])
		-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str.5 lo}])
		registers.a0 = registers.a0 + lo(data[".L.str.5"])
		-- call ([{0 false printf }])
		if functions["printf"] then
			functions["printf"]()
			PC = 25
			continue
		else
			error("No bindings for functions 'printf'")
		end
		PC += 1
	end -- .LBB4_3 (.LBB4_3)
	if PC == 25 then -- .LBB4_3 (extended) 
		-- j ([{0 false .LBB4_4 }])
		do
			PC = 26 -- .LBB4_4
			continue
		end
		PC += 1
	end -- .LBB4_3_end (.LBB4_3_end)
	if PC == 26 then -- .LBB4_4
		-- lw ([{0 true ra } {28 true sp }])
		registers.ra = readi32(memory, registers.sp+28)
		-- lw ([{0 true s0 } {24 true sp }])
		registers.s0 = readi32(memory, registers.sp+24)
		-- addi ([{0 true sp } {0 true sp } {0 false 32 }])
		registers.sp = registers.sp + 32
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
	end -- .LBB4_4 (.LBB4_4)
	if PC == 27 then -- .Lfunc_end4
		PC += 1
	end -- .Lfunc_end4 (.Lfunc_end4)
	if PC == 28 then -- .L.str
		PC += 1
	end -- .L.str (.L.str)
	if PC == 29 then -- .L.str.1
		PC += 1
	end -- .L.str.1 (.L.str.1)
	if PC == 30 then -- .L.str.2
		PC += 1
	end -- .L.str.2 (.L.str.2)
	if PC == 31 then -- .L.str.3
		PC += 1
	end -- .L.str.3 (.L.str.3)
	if PC == 32 then -- .L.str.4
		PC += 1
	end -- .L.str.4 (.L.str.4)
	if PC == 33 then -- .L.str.5
		PC += 1
	end -- .L.str.5 (.L.str.5)
	-- if no PC, or invalid PC then break (look into alternative implementations in the future) 
	if (not PC) or PC == 0 or PC > 33 then
		break
	end
end
