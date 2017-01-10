# one parameter predicates

"""Returns nonzero iff the midpoint and radius of x are both finite floating-point numbers, i.e. not infinities or NaN."""
function isfinite{D,P}(x::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_is_finite), Int, (Ptr{ArbDec{D,P}},), &x)
end

"""isnan or isinf"""
function notfinite{D,P}(x::ArbDec{D,P})
    return 0 == ccall(@libarb(arb_is_finite), Int, (Ptr{ArbDec{D,P}},), &x)
end

function isnan{D,P}(x::ArbDec{D,P})
    return isnan(convert(ArfFloat{P},x))
end
function notnan{D,P}(x::ArbDec{D,P})
    return notnan(convert(ArfFloat{P},x))
end

function isinf{D,P}(x::ArbDec{D,P})
    return isinf(convert(ArfFloat{P},x))
end
function notinf{D,P}(x::ArbDec{D,P})
    return notinf(convert(ArfFloat{P},x))
end

function isposinf{D,P}(x::ArbDec{D,P})
    return isposinf(convert(ArfFloat{P},x))
end
function notposinf{D,P}(x::ArbDec{D,P})
    return notposinf(convert(ArfFloat{P},x))
end

function isneginf{D,P}(x::ArbDec{D,P})
    return isneginf(convert(ArfFloat{P},x))
end
function notneginf{D,P}(x::ArbDec{D,P})
    return notneginf(convert(ArfFloat{P},x))
end


isinteger{T<:Integer}(x::T) = true
notinteger{T<:Integer}(x::T) = false

"""true iff midpoint(x) is an integer and radius(x) is zero"""
function isinteger{D,P}(x::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_is_int), Int, (Ptr{ArbDec{D,P}},), &x)
end
"""true iff midpoint(x) is not an integer or radius(x) is nonzero"""
function notinteger{D,P}(x::ArbDec{D,P})
    return 0 == ccall(@libarb(arb_is_int), Int, (Ptr{ArbDec{D,P}},), &x)
end

"""midpoint(x) and radius(x) are zero"""
function iszero{D,P}(x::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_is_zero), Int, (Ptr{ArbDec{D,P}},), &x)
end
"""true iff midpoint(x) or radius(x) are not zero"""
function notzero{D,P}(x::ArbDec{D,P})
    return 0 == ccall(@libarb(arb_is_zero), Int, (Ptr{ArbDec{D,P}},), &x)
end
"""true iff zero is not within [upperbound(x), lowerbound(x)]"""
function nonzero{D,P}(x::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_is_nonzero), Int, (Ptr{ArbDec{D,P}},), &x)
end

"""true iff midpoint(x) is one and radius(x) is zero"""
function isone{D,P}(x::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_is_one), Int, (Ptr{ArbDec{D,P}},), &x)
end
"""true iff midpoint(x) is not one or midpoint(x) is one and radius(x) is nonzero"""
function notone{D,P}(x::ArbDec{D,P})
    return 0 == ccall(@libarb(arb_is_one), Int, (Ptr{ArbDec{D,P}},), &x)
end


isexact(x::Integer) = true
notexact(x::Integer) = false
"""true iff radius is zero"""
function isexact{D,P}(x::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_is_exact), Int, (Ptr{ArbDec{D,P}},), &x)
end
"""true iff radius is nonzero"""
function notexact{D,P}(x::ArbDec{D,P})
    return 0 == ccall(@libarb(arb_is_exact), Int, (Ptr{ArbDec{D,P}},), &x)
end


"""true iff lowerbound(x) is positive"""
function ispositive{D,P}(x::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_is_positive), Int, (Ptr{ArbDec{D,P}},), &x)
end
"""true iff upperbound(x) is zero or negative"""
function notpositive{D,P}(x::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_is_nonpositive), Int, (Ptr{ArbDec{D,P}},), &x)
end

"""true iff upperbound(x) is negative"""
function isnegative{D,P}(x::ArbDec{D,P})
    return  0 != ccall(@libarb(arb_is_negative), Int, (Ptr{ArbDec{D,P}},), &x)
end
"""true iff lowerbound(x) is zero or positive"""
function notnegative{D,P}(x::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_is_nonnegative), Int, (Ptr{ArbDec{D,P}},), &x)
end

# two parameter predicates

"""true iff midpoint(x)==midpoint(y) and radius(x)==radius(y)"""
function areequal{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_equal), Int, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &x, &y)
end


"""true iff midpoint(x)!=midpoint(y) or radius(x)!=radius(y)"""
function notequal{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return 0 == ccall(@libarb(arb_equal), Int, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &x, &y)
end

"""true iff x and y have a common point"""
function overlap{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_overlaps), Int, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &x, &y)
end

"""true iff x and y have no common point"""
function donotoverlap{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return 0 == ccall(@libarb(arb_overlaps), Int, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &x, &y)
end

"""true iff x spans (covers) all of y"""
function doescontain{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_contains), Int, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &x, &y)
end
"""true iff x does not span (cover) all of y"""
function doesnotcontain{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_contains), Int, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &x, &y)
end

"""true iff y spans (covers) all of x"""
function iscontainedby{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return 0 != ccall(@libarb(arb_contains), Int, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &y, &x)
end
"""true iff y does not span (cover) all of x"""
function notcontainedby{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return 0 == ccall(@libarb(arb_contains), Int, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &y, &x)
end
