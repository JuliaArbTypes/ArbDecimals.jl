for (op,cfunc) in ((:factorial, :arb_fac_ui), (:doublefactorial, :arb_doublefac_ui))
  @eval begin
    function ($op){D,P}(x::ArbDec{D,P})
      signbit(x) && throw(ErrorException("Domain Error: argument is negative"))
      y = trunc(UInt, x)
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, UInt, Int), &z, y, P)
      z
    end
  end
end

function doublefactorial{R<:Real}(xx::R)
   P = precision(ArbDec)
   x = convert(ArbDec{D,P},xx)
   doublefactorial(x)
end

for (op,cfunc) in ((:risingfactorial,:arb_rising),)
  @eval begin
    function ($op){D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
      signbit(x) && throw(ErrorException("Domain Error: argument is negative"))
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int), &z, &x, &y, P)
      z
    end
    function ($op){D,P,R<:Real}(x::ArbDec{D,P}, yy::R, prec::Int=P)
      y = convert(ArbDec{D,P},yy)
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int), &z, &x, &y, P)
      z
    end
  end
end

for (op,cfunc) in ((:agm, :arb_agm), (:polylog, :arb_polylog))
  @eval begin
    function ($op){D,P}(x::ArbDec{D,P}, y::ArbDec{D,P}, prec::Int=P)
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int), &z, &x, &y, P)
      z
    end
    function ($op){D,P,R<:Real}(xx::R, y::ArbDec{D,P}, prec::Int=P)
      x = convert(ArbDec{D,P},xx)
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int), &z, &x, &y, P)
      z
    end
    function ($op){D,P,R<:Real}(x::ArbDec{D,P}, yy::R, prec::Int=P)
      y = convert(ArbDec{D,P},yy)
      z = initializer(ArbDec{D,P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}, Int), &z, &x, &y, P)
      z
    end
  end
end
