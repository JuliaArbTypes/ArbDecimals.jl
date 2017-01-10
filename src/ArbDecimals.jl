module ArbDecimals

export string_all, string_compact, string_small, string_large,
       show_all, show_compact, show_small, show_large,
       two, three, four,
       abz, abz2, invsqrt, addmul, submul, muladd, mulsub,
       isexact, notexact,
       ispositive, notpositive, isnegative, notnegative,
       isposinf, notposinf, isneginf, notneginf,
       notnan, notinf, notfinite,
       iszero, notzero, nonzero, isone, notone, notinteger,
       simeq, nsime, prec, preceq, succ, succeq, # non-strict total ordering comparisons
       (≃), (≄), (≺), (⪯), (≻), (⪰),           #    matched binary operators
       upperbound, lowerbound, bounds,
       areequal, notequal, approxeq, (≊),
       narrow, overlap, donotoverlap,
       doescontain, doesnotcontain, iscontainedby, notcontainedby,
       absz, absz2, invsqrt, pow, root, 
       tanpi, cotpi, logbase, sincos, sincospi, sinhcosh,
       doublefactorial, risingfactorial, rgamma, agm, polylog,
       Dec5, Dec10, Dec15, 
       Dec20, Dec25, Dec30, Dec40, Dec50, Dec60,
       Dec75, Dec80, Dec90, Dec100, Dec125, Dec150, Dec175,
       Dec200, Dec225, Dec250, Dec275, Dec300, Dec325, Dec350, Dec375,
       Dec400, Dec425, Dec450, Dec475, Dec500, Dec525, Dec550, Dec575, Dec600

import Base: hash, convert, promote_rule, STDIN, STDOUT,
             string, show,
             copy, deepcopy, typemax, typemin, realmax, realmin,
             decompose, zero, one,
             isequal, isless, (==),(!=),(<),(<=),(>=),(>),
             min, max, minmax, sort,
             signbit, abs, abs2, inv,
             (+), (-), (*), (/), (^), (%),
             floor, ceil, trunc,
             sqrt, hypot,
             exp, expm1, log, log1p, log2, log10,
             sin, cos, tan, csc, sec, cot, sinc,
             sinh, cosh, tanh, csch, sech, coth, 
             asin, acos, atan, acsc, asec, acot, atan2, 
             asinh, acosh, atanh, acsch, asech, acoth,
             factorial, gamma, digamma, zeta

#using ArbFloats
import ArbFloats: ArfFloat, ArbFloat, @libarb,
                  initializer, c_release_arb,
                  ptr_to_midpoint, ptr_to_radius,
                  midpoint, radius, diameter,
                  upperbound, lowerbound, bounds 

using ReadableNumbers

#=
    environmental defaults are constants
      given by the macros defined here
=#
macro digitsForCompactStrings() 10 end
macro digitsForSmallStrings() 17 end
macro digitsForLargeStrings() 72 end



include("type/ArbDecimal.jl")
include("type/convert.jl")
include("type/promote.jl")
include("type/float.jl")
include("type/interval.jl")

include("basics/predicates.jl")
include("basics/compare.jl")
include("basics/sorting.jl")

include("io/string.jl")
include("io/show.jl")

include("math/arith.jl")
include("math/elementary.jl")
include("math/special.jl")

end # module
