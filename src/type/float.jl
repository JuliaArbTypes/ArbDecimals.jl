# of floating point nature
# typemax,realmax realmax,realmin

typemax{D,P}(::Type{ArbDec{D,P}}) = ArbDec{D,P}("Inf")
typemin{D,P}(::Type{ArbDec{D,P}}) = ArbDec{D,P}("-Inf")
realmax{D,P}(::Type{ArbDec{D,P}}) = ArbDec{D,P}(2)^(P+29)
realmin{D,P}(::Type{ArbDec{D,P}}) = ArbDec{D,P}(2)^(-P-29)


function zero{D,P}(::Type{ArbDec{D,P}})
    z = initializer( ArbDec{D,P} )
    ccall(@libarb(arb_zero), Void, (Ptr{ArbDec}, ), &z)
    return z
end
function zero{T<:ArbDec}(::Type{T})
    z = initializer( ArbDec{ precision(ArbDec) } )
    ccall(@libarb(arb_zero), Void, (Ptr{ArbDec}, ), &z)
    return z
end

function one{D,P}(::Type{ArbDec{D,P}})
    z = initializer( ArbDec{D,P} )
    ccall(@libarb(arb_one), Void, (Ptr{ArbDec}, ), &z)
    return z
end
function one{T<:ArbDec}(::Type{T})
    z = initializer( ArbDec{ precision(ArbDec) } )
    ccall(@libarb(arb_one), Void, (Ptr{ArbDec}, ), &z)
    return z
end
