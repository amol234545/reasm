-- Compiled from RISC-V assembly.
local memory = buffer.create(2048)
local registers = {
    ["zero"] = 0, ["x0"] = 0,
    ["ra"]   = 0, ["x1"] = 0,
    ["sp"]   = 2048, ["x2"] = 0,
    ["gp"]   = 0, ["x3"] = 0,
    ["tp"]   = 0, ["x4"] = 0,
    ["t0"]   = 0, ["x5"] = 0,
    ["t1"]   = 0, ["x6"] = 0,
    ["t2"]   = 0, ["x7"] = 0,
    ["s0"]   = 0, ["fp"] = 0, ["x8"] = 0,
    ["s1"]   = 0, ["x9"] = 0,
    ["a0"]   = 0, ["x10"] = 0,
    ["a1"]   = 0, ["x11"] = 0,
    ["a2"]   = 0, ["x12"] = 0,
    ["a3"]   = 0, ["x13"] = 0,
    ["a4"]   = 0, ["x14"] = 0,
    ["a5"]   = 0, ["x15"] = 0,
    ["a6"]   = 0, ["x16"] = 0,
    ["a7"]   = 0, ["x17"] = 0,
    ["s2"]   = 0, ["x18"] = 0,
    ["s3"]   = 0, ["x19"] = 0,
    ["s4"]   = 0, ["x20"] = 0,
    ["s5"]   = 0, ["x21"] = 0,
    ["s6"]   = 0, ["x22"] = 0,
    ["s7"]   = 0, ["x23"] = 0,
    ["s8"]   = 0, ["x24"] = 0,
    ["s9"]   = 0, ["x25"] = 0,
    ["s10"]  = 0, ["x26"] = 0,
    ["s11"]  = 0, ["x27"] = 0,
    ["t3"]   = 0, ["x28"] = 0,
    ["t4"]   = 0, ["x29"] = 0,
    ["t5"]   = 0, ["x30"] = 0,
    ["t6"]   = 0, ["x31"] = 0,
}
local functions = {
    ["printf"] = function()
        -- read string
        local pointer = registers["a0"]
        local str = ""
        local byte = -1
        while byte ~= 0 do
            byte = buffer.readbits(memory, pointer * 8, 8)  -- read 8 bits (1 byte)
            str = str .. string.char(byte)
            pointer = pointer + 1
        end

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
local data = {}

local function hi(addr)
    return bit32.lshift(bit32.rshift(addr, 12), 12)
end
local function lo(addr)
    return bit32.band(addr, 0xFFF)
end

-- /* Auto generated code starts here */
-- ASM ATTRIBUTE: .attribute	4, 16
-- ASM ATTRIBUTE: .attribute	5, "rv32i2p1_m2p0_a2p1_c2p0_zmmul1p0_zaamo1p0_zalrsc1p0"
-- ASM ATTRIBUTE: .file	"main.c"
-- ASM ATTRIBUTE: .text
-- ASM ATTRIBUTE: .globl	main
-- ASM ATTRIBUTE: .p2align	1
-- ASM ATTRIBUTE: .type	main,@function
function main() -- main
	-- addi ([{0 false sp } {0 false sp } {0 true -32 }])
	registers["sp"] = registers["sp"] + -32
	-- sw ([{0 false ra } {28 true sp }])
	buffer.writei32(memory, registers["sp"]+28, registers["ra"])
	-- sw ([{0 true s0 } {24 true sp }])
	buffer.writei32(memory, registers["sp"]+24, registers["s0"])
	-- addi ([{0 true s0 } {0 false sp } {0 true 32 }])
	registers["s0"] = registers["sp"] + 32
	-- li ([{0 true a0 } {0 true 0 }])
	registers["a0"] = 0
	-- sw ([{0 true a0 } {-20 true s0 }])
	buffer.writei32(memory, registers["s0"]+-20, registers["a0"])
	-- sw ([{0 true a0 } {-12 true s0 }])
	buffer.writei32(memory, registers["s0"]+-12, registers["a0"])
	-- sw ([{0 true a0 } {-16 true s0 }])
	buffer.writei32(memory, registers["s0"]+-16, registers["a0"])
	-- lw ([{0 true a0 } {-16 true s0 }])
	registers["a0"] = buffer.readi32(memory, registers["s0"]+-16)
	-- addi ([{0 true a0 } {0 true a0 } {0 true 5 }])
	registers["a0"] = registers["a0"] + 5
	-- sw ([{0 true a0 } {-16 true s0 }])
	buffer.writei32(memory, registers["s0"]+-16, registers["a0"])
	-- lw ([{0 true a0 } {-16 true s0 }])
	registers["a0"] = buffer.readi32(memory, registers["s0"]+-16)
	-- addi ([{0 true a0 } {0 true a0 } {0 true -3 }])
	registers["a0"] = registers["a0"] + -3
	-- sw ([{0 true a0 } {-16 true s0 }])
	buffer.writei32(memory, registers["s0"]+-16, registers["a0"])
	-- lw ([{0 true a0 } {-16 true s0 }])
	registers["a0"] = buffer.readi32(memory, registers["s0"]+-16)
	-- addi ([{0 true a1 } {0 true a0 } {0 true 2 }])
	registers["a1"] = registers["a0"] + 2
	-- lui ([{0 true a0 } {0 false .L.str hi}])
	registers["a0"] = hi(data["str"])
	-- addi ([{0 true a0 } {0 true a0 } {0 false .L.str lo}])
	registers["a0"] = registers["a0"] + lo(data["str"])
	-- call ([{0 false printf }])
	functions["printf"]() -- invoke provided function printf
	-- lw ([{0 true a0 } {-20 true s0 }])
	registers["a0"] = buffer.readi32(memory, registers["s0"]+-20)
	-- lw ([{0 false ra } {28 true sp }])
	registers["ra"] = buffer.readi32(memory, registers["sp"]+28)
	-- lw ([{0 true s0 } {24 true sp }])
	registers["s0"] = buffer.readi32(memory, registers["sp"]+24)
	-- addi ([{0 false sp } {0 false sp } {0 true 32 }])
	registers["sp"] = registers["sp"] + 32
	-- ret ([])
	return
end -- main (main)
-- ASM ATTRIBUTE: .type	.L.str,@object
-- ASM ATTRIBUTE: .section	.rodata.str1.1,"aMS",@progbits,1
buffer.writestring(memory, 0, "Hello, world! %d\0")
data["str"] = 0 -- represents ^
-- ASM ATTRIBUTE: .ident	"Homebrew clang version 20.1.8"
-- ASM ATTRIBUTE: .section	".note.GNU-stack","",@progbits
-- ASM ATTRIBUTE: .addrsig
-- ASM ATTRIBUTE: .addrsig_sym printf

-- /* Auto generated code ends here */

--return function()
    main()
--end
