
#= imported from ArbFloats
#  simplify using BigNums

convert(::Type{BigInt}, x::String) = parse(BigInt,x)
convert(::Type{BigFloat}, x::String) = parse(BigFloat,x)
=#

# convert ArbDec with other types

function convert{D,P}(::Type{ArbDec{D,P}}, x::UInt64)
    z = initializer(ArbDec{D,P})
    ccall(@libarb(arb_set_ui), Void, (Ptr{ArbDec}, UInt64), &z, x)
    return z
end

function convert{D,P}(::Type{ArbDec{D,P}}, x::Int64)
    z = initializer(ArbDec{D,P})
    ccall(@libarb(arb_set_si), Void, (Ptr{ArbDec}, Int64), &z, x)
    return z
end

function convert{D,P}(::Type{ArbDec{D,P}}, x::Float64)
    z = initializer(ArbDec{D,P})
    ccall(@libarb(arb_set_d), Void, (Ptr{ArbDec}, Float64), &z, x)
    return z
end

function convert{D,P,Sym}(::Type{ArbDec{D,P}}, x::Irrational{Sym})
    bf_precision = precision(BigFloat)
    setprecision(BigFloat, P+24)        
    bf_x = convert(BigFloat, x)
    z = convert(ArbDec{D,P}, bf_x)
    setprecision(BigFloat, bf_precision)
    return z
end

function convert{D,P}(::Type{ArbDec{D,P}}, x::String)
    z = initializer(ArbDec{D,P})
    ok = ccall(@libarb(arb_set_str), Int, (Ptr{ArbDec}, Ptr{UInt8}, Int), &z, x, P)
    return z
end

function convert{D,P}(::Type{String}, x::ArbDec{D,P})
    p = P
    digs = @workingDigitsGivenWorkingBits(p)
    cstr = ccall(@libarb(arb_get_str), Ptr{UInt8}, (Ptr{ArbDec}, Int, UInt), &x, digs, 2%UInt)
    s = unsafe_string(cstr)
    return s
end


convert{D,P}(::Type{ArbDec{D,P}}, x::ArbDec{D,P}) = x

function convert{D,P,E,Q}(::Type{ArbDec{D,P}}, x::ArbDec{E,Q})
    str = string_all(x)
    res = convert(ArbDec{D,P}, str)
    return res
end

# BigNum conversions

function convert{D,P}(::Type{BigFloat}, x::ArbDec{D,P})
    ptr2mid = ptr_to_midpoint(x)
    bf = BigFloat(0)
    rounding_dir = ccall(@libarb(arf_get_mpfr), Int, (Ptr{BigFloat}, Ptr{ArfFloat}, Int), &bf, ptr2mid, 4) # round nearest
    return bf
end
function convert{D,P}(::Type{ArbDec{D,P}}, x::BigFloat)
    af = initializer(ArfFloat{P})
    z  = initializer(ArbDec{D,P})
    ccall(@libarb(arf_set_mpfr), Void, (Ptr{ArfFloat{P}}, Ptr{BigFloat}), &af, &x)
    ccall(@libarb(arb_set_arf), Void, (Ptr{ArbDec{D,P}}, Ptr{ArfFloat{P}}), &z, &af)
    return z 
end

function convert{D,P}(::Type{BigInt}, x::ArbDec{D,P})
   bigfloat = convert(BigFloat, x)
   bigint   = convert(BigInt, trunc(bigfloat))
   return bigint
end
function convert{D,P}(::Type{ArbDec{D,P}}, x::BigInt)
   bigfloat = convert(BigFloat, x)
   z = convert(ArbDec{D,P}, bigfloat)
   return z
end

function convert{D,P}(::Type{Rational{BigInt}}, x::ArbDec{D,P})
    bigfloat     = convert(BigFloat, x)
    numerator, pow2shift, sgn = decompose(bigfloat)
    numer = convert(BigInt, numerator)
    if sgn < 0
       numer = -numer
    end
    denom = BigInt(2)^(-pow2shift)
    return numer // denom
end
function convert{D,P}(::Type{ArbDec{D,P}}, x::Rational{BigInt})
    bigfloat = convert(BigFloat, x)
    z = convert(ArbDec{D,P}, bigfloat)
    return z
end



    





# derived conversions

convert{D,P}(::Type{ArbDec{D,P}}, x::UInt32)  = convert(ArbDec{D,P}, x%UInt64)
convert{D,P}(::Type{ArbDec{D,P}}, x::UInt16)  = convert(ArbDec{D,P}, x%UInt64)
convert{D,P}(::Type{ArbDec{D,P}}, x::UInt8)   = convert(ArbDec{D,P}, x%UInt64)
convert{D,P}(::Type{ArbDec{D,P}}, x::UInt128) = convert(ArbDec{D,P}, string(x))

convert{D,P}(::Type{ArbDec{D,P}}, x::Int32)  = convert(ArbDec{D,P}, x%Int64)
convert{D,P}(::Type{ArbDec{D,P}}, x::Int16)  = convert(ArbDec{D,P}, x%Int64)
convert{D,P}(::Type{ArbDec{D,P}}, x::Int8)   = convert(ArbDec{D,P}, x%Int64)
convert{D,P}(::Type{ArbDec{D,P}}, x::Int128) = convert(ArbDec{D,P}, string(x))

convert{D,P}(::Type{ArbDec{D,P}}, x::Float32) = convert(ArbDec{D,P}, convert(Float64,x))
convert{D,P}(::Type{ArbDec{D,P}}, x::Float16) = convert(ArbDec{D,P}, convert(Float64,x))

function convert{D,P}(::Type{Float64}, x::ArbDec{D,P})
    ptr2mid = ptr_to_midpoint(x)
    fl = ccall(@libarb(arf_get_d), Float64, (Ptr{ArfFloat}, Int), ptr2mid, 4) # round nearest
    return fl
end

function convert{D,P}(::Type{Float32}, x::ArbDec{D,P})
    return convert(Float32, convert(Float64, x))
end
function convert{D,P}(::Type{Float16}, x::ArbDec{D,P})
    return convert(Float16, convert(Float64, x))
end

for I in (:UInt64, :UInt128)
  @eval begin
    function convert{D,P}(::Type{$I}, x::ArbDec{D,P})
        if isinteger(x)
           if notnegative(x)
               return convert($I, convert(BigInt,x))
           else
               throw( DomainError() )
           end
        else
           throw( InexactError() )
        end
    end
  end
end

convert{D,P}(::Type{UInt32}, x::ArbDec{D,P}) = convert(UInt32, convert(UInt64,x))
convert{D,P}(::Type{UInt16}, x::ArbDec{D,P}) = convert(UInt16, convert(UInt64,x))
convert{D,P}(::Type{UInt8}, x::ArbDec{D,P}) = convert(UInt8, convert(UInt64,x))

for I in (:Int64, :Int128)
  @eval begin
    function convert{D,P}(::Type{$I}, x::ArbDec{D,P})
        if isinteger(x)
           return convert($I, convert(BigInt,x))
        else
           throw( InexactError() )
        end
    end
  end
end

convert{D,P}(::Type{Int32}, x::ArbDec{D,P}) = convert(Int32, convert(Int64,x))
convert{D,P}(::Type{Int16}, x::ArbDec{D,P}) = convert(Int16, convert(Int64,x))
convert{D,P}(::Type{Int8}, x::ArbDec{D,P}) = convert(Int8, convert(Int64,x))
