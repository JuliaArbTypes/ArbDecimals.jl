#=
    We use two sets of infixable comparatives.
    The conventional symbols {==,!=,<,<=,>,>=} are defined using
       the Arb C library's implementation of eq,ne,lt,le,gt,ge.
    The predecessor/successor symbols {≃,≄,≺,≼,≻,≽} are defined from
       Hend Dawood's non-strict total ordering for interval values.
       (q.v. Hend's Master's thesis:
        Interval Mathematics Foundations, Algebraic Structures, and Applications)
=#

for (op,cop) in ((:(==), :(arb_eq)), (:(!=), :(arb_ne)),
                 (:(<=), :(arb_le)), (:(>=), :(arb_ge)),
                 (:(<), :(arb_lt)),  (:(>), :(arb_gt))  )
  @eval begin
    function ($op){D,P}(a::ArbDec{D,P}, b::ArbDec{D,P})
        return Bool(ccall(@libarb($cop), Cint, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &a, &b) )
    end
    ($op){P,Q}(a::ArbDec{P}, b::ArbDec{Q}) = ($op)(promote(a,b)...)
    ($op){D,P,R<:Real}(a::ArbDec{D,P}, b::R) = ($op)(promote(a,b)...)
    ($op){D,P,R<:Real}(a::R, b::ArbDec{D,P}) = ($op)(promote(a,b)...)
  end
end

function (≃){D,P}(a::ArbDec{D,P}, b::ArbDec{D,P})
    return Bool(ccall(@libarb(arb_eq), Cint, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &a, &b))
end
simeq{D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}) = (≃)(a,b)

function (≄){D,P}(a::ArbDec{D,P}, b::ArbDec{D,P})
    return !Bool(ccall(@libarb(arb_eq), Cint, (Ptr{ArbDec{D,P}}, Ptr{ArbDec{D,P}}), &a, &b))
end
nsime{D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}) = (≄)(a,b)

function (⪰){D,P}(a::ArbDec{D,P}, b::ArbDec{D,P})
    alo, ahi = bounds(a)
    blo, bhi = bounds(b)
    return (alo < blo) || ((alo == blo) & (ahi <= bhi))
end
succeq{D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}) = (⪰)(a,b)

function (≻){D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}) # (a ≼ b) & (a ≄ b)
    alo, ahi = bounds(a)
    blo, bhi = bounds(b)
    return (alo < blo) || ((alo == blo) & (ahi < bhi))
end
succ{D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}) = (≻)(a,b)

function (⪯){D,P}(a::ArbDec{D,P}, b::ArbDec{D,P})
    alo, ahi = bounds(a)
    blo, bhi = bounds(b)
    return (alo > blo) || ((alo == blo) & (ahi >= bhi))
end
preceq{D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}) = (⪯)(a,b)

function (≺){D,P}(a::ArbDec{D,P}, b::ArbDec{D,P})
    alo, ahi = bounds(a)
    blo, bhi = bounds(b)
    return (alo > blo) || ((alo == blo) & (ahi > bhi))
end
prec{D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}) = (≺)(a,b)


# for sorted ordering
isequal{D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}) = !(a != b)
isless{ D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}) = succ(a,b)
isequal{D,P}(a::Void, b::ArbDec{D,P}) = false
isequal{D,P}(a::ArbDec{D,P}, b::Void) = false
isless{ D,P}(a::Void, b::ArbDec{D,P}) = true
isless{ D,P}(a::ArbDec{D,P}, b::Void) = true


function max{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return (x + y + abs(x - y))/2
end

function min{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return (x + y - abs(x - y))/2
end
#=
min{D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}) = smartvalue(a) < smartvalue(b) ? a : b
max{D,P}(a::ArbDec{D,P}, b::ArbDec{D,P}) = smartvalue(b) < smartvalue(a) ? a : b
function min2{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return
        if donotoverlap(x,y)
            x < y ? x : y
        else
            xlo, xhi = bounds(x)
            ylo, yhi = bounds(y)
            lo,hi = min(xlo, ylo), min(xhi, yhi)
            md = (hi+lo)/2
            rd = (hi-lo)/2
            midpoint_radius(md, rd)
        end
end
function max2{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return
        if donotoverlap(x,y)
            return x > y ? x : y
        else
            xlo, xhi = bounds(x)
            ylo, yhi = bounds(y)
            lo,hi = max(xlo, ylo), max(xhi, yhi)
            md = (hi+lo)/2
            rd = (hi-lo)/2
            return midpoint_radius(md, rd)
        end
end
=#
#=
function max{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
    return ((x>=y) | !(y<x)) ? x : y
end
=#

function minmax{D,P}(x::ArbDec{D,P}, y::ArbDec{D,P})
   return min(x,y), max(x,y) # ((x<=y) | !(y>x)) ? (x,y) : (y,x)
end


# experimental ≖ ≗
(eq){D,P}(x::ArbDec{D,P}, y::ArbDec{D,P}) = !(x != y)
(eq){D,P,E,Q}(x::ArbDec{D,P}, y::ArbDec{E,Q}) = (eq)(promote(x,y)...)
(eq){D,P}(x::ArbDec{D,P}, y::Real) = (eq)(promote(x,y)...)
(eq){D,P}(x::Real, y::ArbDec{D,P}) = (eq)(promote(x,y)...)

(≗){D,P}(x::ArbDec{D,P}, y::ArbDec{D,P}) = !(x != y)
(≗){D,P,E,Q}(x::ArbDec{D,P}, y::ArbDec{E,Q}) = (eq)(promote(x,y)...)
(≗){D,P}(x::ArbDec{D,P}, y::Real) = (eq)(promote(x,y)...)
(≗){D,P}(x::Real, y::ArbDec{D,P}) = (eq)(promote(x,y)...)

(neq){D,P}(x::ArbDec{D,P}, y::ArbDec{D,P}) = donotoverlap(x, y)
(neq){D,P,E,Q}(x::ArbDec{D,P}, y::ArbDec{E,Q}) = (donotoverlap)(promote(x,y)...)
(neq){D,P}(x::ArbDec{D,P}, y::Real) = (neq)(promote(x,y)...)
(neq){D,P}(x::Real, y::ArbDec{D,P}) = (neq)(promote(x,y)...)
