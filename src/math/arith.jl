function signbit{D,P}(x::ArbDec{D,P})
    0 != ccall(@libarb(arb_is_negative), Int, (Ptr{ArbDec{D,P}},), &x)
end




for (op,cfunc) in ((:-,:arb_neg), (:sign, :arb_sgn), (:abz, :arb_abs))
  @eval begin
    function ($op){D,P}(x::ArbDec{D,P})
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &z, &x)
      return z
    end
  end
end


function abs{D,P}(x::ArbDec{D,P})
    z  = initializer(ArbDec{D,P})
    lo = initializer(ArfFloat{P})
    hi = initializer(ArfFloat{P})
    ccall(@libarb(arb_get_abs_lbound_arf), Void, (Ptr{ArfFloat{P}}, Ptr{ArbDec{D,P}}, Int), &lo, &x, P) 
    ccall(@libarb(arb_get_abs_ubound_arf), Void, (Ptr{ArfFloat{P}}, Ptr{ArbDec{D,P}}, Int), &hi, &x, P)
    ccall(@libarb(arb_set_interval_arf), Void, (Ptr{ArbDec{D,P}}, Ptr{ArfFloat{P}}, Ptr{ArfFloat{P}}, Int), &z, &lo, &hi, P)
    return z
end


function abs2{D,P}(x::ArbDec{D,P})
    a = abs(x)
    return a*a
end

function abz2{T<:ArbDec}(x::T)
    a = abz(x)
    return a*a
end

for (op,cfunc) in ((:inv, :arb_inv), (:sqrt, :arb_sqrt), (:invsqrt, :arb_rsqrt))
  @eval begin
    function ($op){D,P}(x::ArbDec{D,P})
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int), &z, &x, P)
      return z
    end
  end
end


for (op,cfunc) in ((:+,:arb_add), (:-, :arb_sub), (:*, :arb_mul), (:/, :arb_div), (:hypot, :arb_hypot))
  @eval begin
    function ($op){D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int), &z, &x, &y, P)
      return z
    end
  end
end


for (op,cfunc) in ((:+,:arb_add_si), (:-, :arb_sub_si), (:*, :arb_mul_si), (:/, :arb_div_si))
  @eval begin
    function ($op){D,P}(x::ArbDec{D,P}, y::Int)
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int, Int), &z, &x, y, P)
      return z
    end
  end
end

(+){D,P}(x::Int, y::ArbDec{D,P}) = (+)(y, x)
(-){D,P}(x::Int, y::ArbDec{D,P}) = (-)((-)(y, x))
(*){D,P}(x::Int, y::ArbDec{D,P}) = (*)(y, x)
(/){D,P}(x::Int, y::ArbDec{D,P}) = (inv)((/)(y, x))


for (op,cfunc) in ((:addmul,:arb_addmul), (:submul, :arb_submul))
  @eval begin
    function ($op){D,P}(w::ArbDec{D,P}, x::ArbDec{D,P}, y::ArbDec{D,P})
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int), &z, &w, &x, &y, P)
      z
    end
  end
end

muladd{D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}, c::ArbDec{D,P}) = addmul(c,a,b)
mulsub{D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}, c::ArbDec{D,P}) = addmul(-c,a,b)
