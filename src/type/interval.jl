# of the interval nature
# parts and aspects
# midpoint, radius, lowerbound, upperbound

@inline function ptr_to_midpoint{T<:ArbDec}(x::T) # Ptr{ArfFloat}
    return ccall(@libarb(arb_mid_ptr), Ptr{ArfFloat}, (Ptr{T}, ), &x)
end
@inline function ptr_to_radius{T<:ArbDec}(x::T) # Ptr{ArfFloat}
    return ccall(@libarb(arb_rad_ptr), Ptr{ArfFloat}, (Ptr{T}, ), &x)
end

function midpoint{D,P}(x::ArbDec{D,P})
    z = initializer( ArbDec{D,P} )
    ccall(@libarb(arb_get_mid_arb), Void, (Ptr{ArbDec}, Ptr{ArbDec}), &z, &x)
    return z
end

function radius{D,P}(x::ArbDec{D,P})
    z = initializer( ArbDec{D,P} ) # is 0
    if !isexact(x)
        ccall(@libarb(arb_get_rad_arb), Void, (Ptr{ArbDec}, Ptr{ArbDec}), &z, &x)
    end
    return z
end

function diameter{D,P}(x::ArbDec{D,P})
    r = radius(x)
    return r+r
end

function upperbound{D,P}(x::ArbDec{D,P})
    a = initializer( ArfFloat{D,P} )
    z = initializer( ArbDec{D,P} )
    ccall(@libarb(arb_get_ubound_arf), Void, (Ptr{ArfFloat}, Ptr{ArbDec}, Int), &a, &x, P)
    ccall(@libarb(arb_set_arf), Void, (Ptr{ArbDec}, Ptr{ArfFloat}), &z, &a)
    return z
end

function lowerbound{D,P}(x::ArbDec{D,P})
    a = initializer( ArfFloat{D,P} )
    z = initializer( ArbDec{D,P} )
    ccall(@libarb(arb_get_lbound_arf), Void, (Ptr{ArfFloat}, Ptr{ArbDec}, Int), &a, &x, P)
    ccall(@libarb(arb_set_arf), Void, (Ptr{ArbDec}, Ptr{ArfFloat}), &z, &a)
    return z
end

bounds{D,P}(x::ArbDec{D,P}) = ( lowerbound(x), upperbound(x) )


"""
isolate_nonnegative_content(x::ArbDec)
returns x without any content < 0
if x is strictly < 0, returns ArbDec's NaN
"""
function isolate_nonnegative_content{D,P}(x::ArbDec{D,P})
    lo, hi = bounds(x)
    z = if lo > 0
              x
          elseif hi < 0
              T(NaN)
          else
              mid = hi * 0.5
              r = Float32(mid)
              dr = eps(r) * 0.125
              m = Float64(mid)
              while Float64(r) > m
                  r = r - dr
              end
              midpoint_radius(mid, r)
          end
    return z
end

"""
isolate_positive_content(x::ArbDec)
returns x without any content <= 0
if x is strictly <= 0, returns ArbDecs' NaN
"""
function isolate_positive_content{D,P}(x::ArbDec{D,P})
    lo, hi = bounds(x)
    z = if lo > 0
              x
          elseif hi <= 0
              T(NaN)
          else
              mid = hi * 0.5
              r = Float32(mid)
              dr = 0.125 * eps(r)
              m = Float64(mid)
              while Float64(r) >= m
                  r = r - dr
              end
              midpoint_radius(mid, r)
          end
    return z
end

"""
force_nonnegative_content(x::ArbDec)
returns x without any content < 0
if x is strictly < 0, returns 0
"""
function force_nonnegative_content{D,P}(x::ArbDec{D,P})
    lo, hi = bounds(x)
    z = if lo >= 0
              x
          elseif hi < 0
              zero(T)
          else
              isolate_nonnegative_content(x)
          end
    return z
end

"""
force_positive_content(x::ArbDec)
returns x without any content <= 0
if x is strictly <= 0, returns eps(lowerbound(x))
"""
function force_positive_content{D,P}(x::ArbDec{D,P})
    lo, hi = bounds(x)
    z = if lo > 0
              x
          elseif hi < 0
              eps(lo)
          else
              isolate_positive_content(x)
          end
    return z
end

"""
Returns the effective relative error of x measured in bits,
  defined as the difference between the position of the
  top bit in the radius and the top bit in the midpoint, plus one.
  The result is clamped between plus/minus ARF_PREC_EXACT.
"""
function relativeError{D,P}(x::ArbDec{D,P})
    re_bits = ccall(@libarb(arb_rel_error_bits), Int, (Ptr{ArbDec},), &x)
    return re_bits
end

"""
Returns the effective relative accuracy of x measured in bits,
  equal to the negative of the return value from relativeError().
"""
function relativeAccuracy{D,P}(x::ArbDec{D,P})
    ra_bits = ccall(@libarb(arb_rel_accuracy_bits), Int, (Ptr{ArbDec},), &x)
    return ra_bits
end

"""
Returns the number of bits needed to represent the absolute value
  of the mantissa of the midpoint of x, i.e. the minimum precision
  sufficient to represent x exactly.
  Returns 0 if the midpoint of x is a special value.
"""
function midpointPrecision{D,P}(x::ArbDec{D,P})
    mp_bits = ccall(@libarb(arb_bits), Int, (Ptr{ArbDec},), &x)
    return mp_bits
end

"""
Sets y to a trimmed copy of x: rounds x to a number of bits equal
  to the accuracy of x (as indicated by its radius), plus a few
  guard bits. The resulting ball is guaranteed to contain x,
  but is more economical if x has less than full accuracy.
"""
function trimmed{D,P}(x::ArbDec{D,P})
    z = initializer( ArbDec{D,P} )
    ccall(@libarb(arb_trim), Void, (Ptr{ArbDec}, Ptr{ArbDec}), &z, &x)
    return z
end
