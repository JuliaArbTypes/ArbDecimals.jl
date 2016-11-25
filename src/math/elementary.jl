
for (op,cfunc) in ((:exp,:arb_exp), (:expm1, :arb_expm1),
    (:log,:arb_log), (:log1p, :arb_log1p),
    (:sin, :arb_sin), (:sinpi, :arb_sinpi), (:cos, :arb_cos), (:cospi, :arb_cospi),
    (:tan, :arb_tan), (:cot, :arb_cot),
    (:sinh, :arb_sinh), (:cosh, :arb_cosh), (:tanh, :arb_tanh), (:coth, :arb_coth),
    (:asin, :arb_asin), (:acos, :arb_asin), (:atan, :arb_atan),
    (:asinh, :arb_asinh), (:acosh, :arb_asinh), (:atanh, :arb_atanh),
    (:sinc, :arb_sinc),
    (:gamma, :arb_gamma), (:lgamma, :arb_lgamma), (:zeta, :arb_zeta),
    (:digamma, :arb_digamma), (:rgamma, :arb_rgamma)
    )    
  @eval begin
    function ($op){D,P}(x::ArbDec{D,P})
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int), &z, &x, P)
      return z
    end
  end
end



function logbase{D,P}(x::ArbDec{D,P}, base::Int)
    b = UInt(abs(base))
    z = initializer(ArbDec{D,P})
    ccall(@libarb(arb_log_base_ui), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, UInt, Int), &z, &x, b, P)
    return z
end

log2{D,P}(x::ArbDec{D,P}) = logbase(x, 2)
log10{D,P}(x::ArbDec{D,P}) = logbase(x, 10)


for (op,cfunc) in ((:sincos, :arb_sin_cos), (:sincospi, :arb_sin_cos_pi), (:sinhcosh, :arb_sinh_cosh))
  @eval begin
    function ($op){D,P}(x::ArbDec{D,P})
        sz = initializer(ArbDec{D,P})
        cz = initializer(ArbDec{D,P})
        ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int), &sz, &cz, &x, P)
        return sz, cz
    end
  end
end


function atan2{D,P}(a::ArbDec{D,P}, b::ArbDec{D,P})
    z = ArbDec{D,P}()
    ccall(@libarb(arb_atan2), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int), &z, &a, &b, P)
    return z
end



for (op,cfunc) in ((:root, :arb_root_ui),)
  @eval begin
    function ($op){D,P}(x::ArbDec{D,P}, y::UInt)
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, UInt, Int), &z, &x, y, P)
      return z
    end
  end
end

function root{D,P}(x::ArbDec{D,P}, y::Int)
    return y < 0 ? pow(x, -y) : root(x, y%UInt)
end

for (op,cfunc) in ((:^,:arb_pow), (:pow,:arb_pow))
  @eval begin
    function ($op){D,P,I<:Integer}(x::ArbDec{D,P}, y::I)
      sy,ay = signbit(y), abs(y)
      yy = ArbDec{D,P}(ay)
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int), &z, &x, &yy, P)
      return sy ? inv(z) : z
    end
  end 
end

