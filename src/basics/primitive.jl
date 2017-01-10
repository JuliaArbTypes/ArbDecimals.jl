
for (op, i) in ((:two,:2), (:three,:3), (:four, :4))
  @eval begin
    function ($op){D,P}(::ArbDec{D,P}ype{ArbDec{D,P}})
        z = initializer(ArbDec{D,P})
        ccall(@libarb(arb_set_si), Void, (Ptr{ArbDec{D,P}}, Int), &z, $i)
        return z
    end
  end
end

weakcopy{D,P}(x::ArbDec{D,P}) = WeakRef(x)

for fn in (:copy, :deepcopy)
  @eval begin
    function ($fn){D,P}(x::ArbDec{D,P})
        z = initializer(ArbDec{D,P})
        ccall(@libarb(arb_set), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &z, &x)
        return z
    end
    function ($fn){D,P}(x::ArbDec{D,P})
        P = precision(T)
        z = initializer(ArbDec{D,P})
        ccall(@libarb(arb_set), Void, (Ptr{ArbDec}, Ptr{ArbDec}), &z, &x)
        return z
    end
  end
end

function copyradius{D,P}(target::ArbDec{D,P}, source::ArbDec{D,P})
    z = deepcopy(target)
    z.radius_exponentOf2 = source.radius_exponentOf2
    z.radius_significand = source.radius_significand
    return z
end

function copymidpoint{D,P}(target::ArbDec{D,P}, source::ArbDec{D,P})
    z = deepcopy(target)
    z.exponentOf2  = source.exponentOf2
    z.nwords_sign  = source.nwords_sign
    z.significand1 = source.significand1
    z.significand2 = source.significand2
    return z
end

function midpoint_radius{D,P}(x::ArbDec{D,P})
    return midpoint(x), radius(x)
end

function midpoint_radius{D,P}(midpt::ArbDec{D,P}, radius::ArbDec{D,P})
    z = midpoint(midpt)
    ccall(@libarb(arb_add_error), Void, (Ptr{ArbDec}, Ptr{ArbDec}), &z, &radius)
    return z
end

function midpoint_radius{D,P}(midpoint::ArbDec{D,P}, radius::Float64)
    rad = convert(T, radius)
    return midpoint_radius(midpoint, rad)
end

function bounds{D,P}(lower::ArbDec{D,P}, upper::ArbDec{D,P})
    lowerlo, lowerhi = bounds(lower)
    upperlo, upperhi = bounds(upper)
    lo = lowerlo <= upperlo ? lowerlo : upperlo
    hi = lowerhi >= upperhi ? lowerhi : upperhi
    # rad = (hi - lo) * 0.5
    mid = hi*0.5 + lo*0.5
    rad = hi - mid
    r = Float32(rad)
    dr = 0.5 * eps(r)
    z = midpoint_radius(mid, r)
    tstlo, tsthi = bounds(z)
    while (tstlo > lo) || (tsthi < hi)
        z = midpoint_radius(mid, r+dr)
        tstlo, tsthi = bounds(z)
    end
    return z
end

"""
Rounds x to a number of bits equal to the accuracy of x (as indicated by its radius), plus a few guard bits.
The resulting ball is guaranteed to contain x, but is more economical if x has less than full accuracy.
(from arb_trim documentation)
"""
function trim{D,P}(x::ArbDec{D,P})
    z = initializer(ArbDec{D,P})
    ccall(@libarb(arb_trim), Void, (Ptr{ArbDec}, Ptr{ArbDec}), &z, &x)
    return z
end

"""
Rounds x to a clean estimate of x as a point value.
"""
function tidy{D,P}(x::ArbDec{D,P})
    s = smartarbstring(x)
    return (T)(s)
end


function decompose{D,P}(x::ArbDec{D,P})
    # decompose x as num * 2^pow / den
    # num, pow, den = decompose(x)
    bfprec=precision(BigFloat)
    setprecision(BigFloat,P)
    bf = convert(BigFloat, x)
    n,p,d = decompose(bf)
    setprecision(BigFloat,bfprec)
    return n,p,d
end
