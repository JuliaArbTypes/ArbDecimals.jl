# Promotion
for T in (:Int128, :Int64, :Int32, :Int16, :Float64, :Float32, :Float16,
          :(Rational{Int64}), :(Rational{Int32}), :(Rational{Int16}),
          :String)
  @eval promote_rule{D,P}(::Type{ArbDec{D,P}}, ::Type{$T}) = ArbDec
end

float{D,P}(x::ArbDec{D,P}) = x

promote_rule{D,P}(::Type{ArbDec{D,P}}, ::Type{BigFloat}) = ArbDec
promote_rule{D,P}(::Type{ArbDec{D,P}}, ::Type{BigInt}) = ArbDec
promote_rule{D,P}(::Type{ArbDec{D,P}}, ::Type{Rational{BigInt}}) = Rational{BigInt}

promote_rule{D1,P1,D2,P2}(::Type{ArbDec{D1,P1}}, ::Type{ArbDec{D2,P2}}) =
    ifelse(D1>D2, ArbDec{D1,P1}, ArbDec{D2,P2})
