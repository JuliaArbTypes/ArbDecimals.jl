function string_all{D,P}(x::ArbDec{D,P})
    cstr = ccall(@libarb(arb_get_str), Ptr{UInt8}, (Ptr{ArbDec}, Int, UInt), &x, D, 2%UInt)
    str = unsafe_string(cstr)
    return str
end

function string_compact{D,P}(x::ArbDec{D,P})
    digs = min(D, @digitsForCompactStrings())
    cstr = ccall(@libarb(arb_get_str), Ptr{UInt8}, (Ptr{ArbDec}, Int, UInt), &x, digs, 2%UInt)
    str = unsafe_string(cstr)
    return str
end

function string{D,P}(x::ArbDec{D,P})
    cstr = ccall(@libarb(arb_get_str), Ptr{UInt8}, (Ptr{ArbDec}, Int, UInt), &x, D, 2%UInt)
    str = unsafe_string(cstr)
    return str
end

function string{D,P}(x::ArbDec{D,P}, digs::Int)
    digs = min(D, digs)
    cstr = ccall(@libarb(arb_get_str), Ptr{UInt8}, (Ptr{ArbDec}, Int, UInt), &x, digs, 2%UInt)
    str = unsafe_string(cstr)
    return str
end

function string_small{D,P}(x::ArbDec{D,P}, digs::Int=@digitsForSmallStrings())
    digs = min(D, digs)
    cstr = ccall(@libarb(arb_get_str), Ptr{UInt8}, (Ptr{ArbDec}, Int, UInt), &x, digs, 2%UInt)
    str = unsafe_string(cstr)
    return str
end

function string_large{D,P}(x::ArbDec{D,P}, digs::Int=@digitsForLargeStrings())
    digs = min(D, digs)
    cstr = ccall(@libarb(arb_get_str), Ptr{UInt8}, (Ptr{ArbDec}, Int, UInt), &x, digs, 2%UInt)
    str = unsafe_string(cstr)
    return str
end

# N.B. internal use only 
# ---- never display this through the application interface
#
function string_full{D,P}(x::ArbDec{D,P})
    digs = @workingDigitsGivenWorkingBits(P)
    cstr = ccall(@libarb(arb_get_str), Ptr{UInt8}, (Ptr{ArbDec}, Int, UInt), &x, digs, 2%UInt)
    str = unsafe_string(cstr)
    return str
end

