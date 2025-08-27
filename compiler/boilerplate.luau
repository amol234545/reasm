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
        local pointer = registers["a0"]
        local str = ""
        local byte = -1
        while byte ~= 0 do
            byte = buffer.readbits(memory, pointer * 8, 8)  -- read 8 bits (1 byte)
            str = str .. string.char(byte)
            pointer = pointer + 1
        end
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
--{code here}
-- /* Auto generated code ends here */

--return function()
main()
--end
