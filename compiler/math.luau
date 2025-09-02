--- Math
local math_wrappers = {
    -- Trigonometric
    sin = math.sin, cos = math.cos, tan = math.tan,
    asin = math.asin, acos = math.acos, atan = math.atan,
    atan2 = math.atan2,

    -- Hyperbolic
    sinh = math.sinh, cosh = math.cosh, tanh = math.tanh,
    asinh = function(x) return math.log(x + math.sqrt(x*x + 1)) end,
    acosh = function(x) return math.log(x + math.sqrt(x*x - 1)) end,
    atanh = function(x) return 0.5 * math.log((1 + x) / (1 - x)) end,

    -- Exponential & Log
    exp = math.exp, log = math.log, log10 = math.log10,
    log2 = function(x) return math.log(x) / math.log(2) end,

    -- Power
    sqrt = math.sqrt, cbrt = function(x) return x^(1/3) end, pow = function(x,y) return x^y end,
    hypot = function(x,y) return math.sqrt(x^2 + y^2) end,

    -- Rounding
    ceil = math.ceil, floor = math.floor,
    trunc = function(x) return x>0 and math.floor(x) or math.ceil(x) end,
    round = function(x) return math.floor(x + 0.5) end,

    -- Misc
    fabs = math.abs,
    copysign = function(x,y) return math.abs(x) * (y>=0 and 1 or -1) end,
    fmax = math.max, fmin = math.min,
    fma = function(x,y,z) return x*y + z end,
    fmod = function(x,y) return x % y end,

    -- Classification
    isnan = function(x) return x ~= x end,
    isinf = function(x) return x == math.huge or x == -math.huge end,
    signbit = function(x) return x < 0 end,
}

for name, func in pairs(math_wrappers) do
    functions[name] = function()
        registers.f10 = func(registers.f10,registers.f11,registers.f12)
    end
end
